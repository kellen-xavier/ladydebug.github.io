#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'date'
require 'fileutils'
require 'json'
require 'open3'
require 'tmpdir'
require 'uri'
require 'yaml'

ROOT = File.expand_path('..', __dir__)

def assert(condition, message)
  raise message unless condition
end

def menu_links(html)
  html.scan(/<a\b([^>]*\brole="menuitem"[^>]*)>/m).map do |attributes|
    attributes.first.scan(/([\w-]+)="([^"]*)"/).to_h.transform_values { |value| CGI.unescapeHTML(value) }
  end
end

checks = {}
Dir.mktmpdir('ladydebug-multilingual-') do |work|
  content = File.join(work, 'content')
  fixtures = {
    '_index.md' => "---\ntitle: Blog\n---\nMinhas notas.\n",
    '_index.en.md' => "---\ntitle: Blog\n---\nMy notes.\n",
    'docs/_index.md' => "---\ntitle: Posts\ncascade:\n  type: blog\n---\n",
    'docs/_index.en.md' => "---\ntitle: Posts\ncascade:\n  type: blog\n---\n",
    'docs/example/index.md' => "---\ntitle: Meu estudo\ndate: 2020-01-01\nfeatured: true\n---\nTexto em português.\n",
    'docs/example/index.en.md' => "---\ntitle: My study\ndate: 2020-01-01\nfeatured: true\n---\nEnglish text.\n\n![Example](image.jpg)\n",
    'docs/only-portuguese.md' => "---\ntitle: Sem tradução\ndate: 2020-01-02\n---\nPortuguês.\n"
  }
  fixtures.each do |name, text|
    path = File.join(content, name)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, text)
  end
  FileUtils.cp(File.join(ROOT, 'assets/image/icons/cat-icon.jpg'), File.join(content, 'docs/example/image.jpg'))
  data = File.join(work, 'data')
  FileUtils.mkdir_p(data)
  FileUtils.cp(File.join(ROOT, 'data/dock.yaml'), File.join(data, 'dock.yaml'))
  File.write(File.join(data, 'events.yaml'), [{
    'date' => '2026-10-29', 'title' => 'Encontro de estudos',
    'title_en' => 'Study meetup', 'url' => 'https://example.org/event'
  }].to_yaml)

  builds = {}
  { 'root' => 'https://example.org/', 'subpath' => 'http://localhost:1313/blog/' }.each do |name, base|
    destination = File.join(work, name)
    out, err, status = Open3.capture3(
      { 'HUGO_RESOURCEDIR' => File.join(work, 'resources'), 'HUGO_DATADIR' => data },
      'hugo', '--source', ROOT, '--contentDir', content, '--destination', destination,
      '--baseURL', base, '--noBuildLock'
    )
    abort("Hugo failed:\n#{out}\n#{err}") unless status.success?
    builds[name] = destination
  end

  page = ->(route, build = 'root') { File.read(File.join(builds.fetch(build), route, 'index.html')) }

  checks['Portuguese keeps its original URLs and English uses /en/'] = lambda do
    assert(page.call('docs/example').include?('Texto em português.'), 'Portuguese page changed')
    assert(page.call('en/docs/example').include?('English text.'), 'English page missing')
  end
  checks['the header uses the accessible native language switcher'] = lambda do
    html = page.call('')
    assert(html.match?(/<button\b[^>]*class="[^"]*hextra-language-switcher/m), 'Native switcher missing')
    assert(html.include?('aria-haspopup="menu"'), 'Language menu semantics missing')
    assert(menu_links(html).any? { |link| link['href'] == '/en/' }, 'English homepage option missing')
  end
  checks['switching a translated post preserves the current post in both directions'] = lambda do
    assert(menu_links(page.call('docs/example')).any? { |link| link['href'] == '/en/docs/example/' }, 'English counterpart missing')
    assert(menu_links(page.call('en/docs/example')).any? { |link| link['href'] == '/docs/example/' }, 'Portuguese counterpart missing')
  end
  checks['posts without a translation fall back to the chosen language homepage'] = lambda do
    assert(menu_links(page.call('docs/only-portuguese')).any? { |link| link['href'] == '/en/' }, 'Missing-translation fallback is broken')
  end
  checks['language links respect local preview and subdirectory hosting'] = lambda do
    links = menu_links(page.call('docs/example', 'subpath'))
    assert(links.any? { |link| link['href'] == '/blog/en/docs/example/' }, 'Subdirectory language URL is incorrect')
  end
  checks['English homepage lists only English posts with localized labels and months'] = lambda do
    html = page.call('en')
    assert(html.include?('My study') && !html.include?('Meu estudo'), 'Homepage mixes languages')
    %w[Highlights January].each { |label| assert(html.include?(label), "Missing English label #{label}") }
    assert(html.include?('On this page'), 'English contents label missing')
  end
  checks['translated page bundles reuse images without copying them'] = lambda do
    html = page.call('en/docs/example')
    image = html.scan(/<img\b([^>]*)>/m).map { |a| a.first.scan(/([\w-]+)="([^"]*)"/).to_h }.find { |a| a['alt'] == 'Example' }
    assert(image, 'Translated post image missing')
    path = URI.join('https://example.org/en/docs/example/', image['src']).path
    assert(File.file?(File.join(builds.fetch('root'), path.delete_prefix('/'))), 'Translated image URL does not resolve')
  end
  checks['the external Google Translate integration is absent'] = lambda do
    assert(!page.call('').include?('translate.google.com'), 'External translation link still exists')
    assert(!File.exist?(File.join(ROOT, 'layouts/_partials/translation-link.html')), 'External translation partial still exists')
  end
  checks['dock controls keep translated accessible names when mobile labels are hidden'] = lambda do
    html = page.call('en')
    %w[Music Calendar Drafts].each do |label|
      assert(html.match?(/<button\b[^>]*aria-label="#{label}"[^>]*>/m), "Missing accessible dock name #{label}")
    end
  end
  checks['every published post has an English source counterpart'] = lambda do
    missing = Dir.glob(File.join(ROOT, 'content/docs/**/*.md')).reject { |path| path.end_with?('.en.md') }.filter_map do |path|
      metadata = YAML.safe_load(File.read(path).split('---', 3)[1], permitted_classes: [Date, Time])
      next if metadata['draft'] || File.basename(path).start_with?('_index')
      path unless File.file?(path.sub(/\.md$/, '.en.md'))
    end
    assert(missing.empty?, "English translations missing:\n#{missing.join("\n")}")
  end
  checks['calendar panel has localized navigation and a month table in both languages'] = lambda do
    { '' => ['Mês anterior', 'Próximo mês', 'Hoje'], 'en' => ['Previous month', 'Next month', 'Today'] }.each do |route, labels|
      html = page.call(route)
      assert(html.include?('data-calendar'), "Calendar missing on #{route}")
      language = route.empty? ? 'pt' : 'en'
      assert(html.match?(/data-locale="#{language}(?:-[A-Za-z]+)?"/), 'Calendar locale is empty or incorrect')
      assert(html.match?(/<table\b[^>]*data-calendar-table/m), 'Month table missing')
      labels.each { |label| assert(html.include?(label), "Calendar label missing: #{label}") }
      assert(html.include?('calendar.min.'), 'Calendar JavaScript is not loaded')
    end
  end
  checks['event data reaches the calendar with the selected language and date intact'] = lambda do
    { '' => 'Encontro de estudos', 'en' => 'Study meetup' }.each do |route, expected|
      attribute = page.call(route).match(/data-events="([^"]*)"/)
      assert(attribute, 'Calendar event data missing')
      events = JSON.parse(CGI.unescapeHTML(attribute[1]))
      assert(events.first == { 'date' => '2026-10-29', 'title' => expected, 'url' => 'https://example.org/event' }, 'Calendar event payload is incorrect')
    end
  end
  checks['both languages load the sparkle effect assets without changing the page content'] = lambda do
    ['', 'en'].each do |route|
      html = page.call(route)
      assert(html.include?('cursor-trail.min.'), 'Cursor trail script missing')
      assert(html.include?('cursor-trail-style.min.'), 'Cursor trail stylesheet missing')
      assert(html.include?('class="dock"'), 'Existing dock missing')
    end
  end

  failures = checks.count do |name, check|
    check.call
    puts "PASS #{name}"
    false
  rescue StandardError => error
    warn "FAIL #{name}: #{error.message}"
    true
  end
  puts "#{checks.length - failures}/#{checks.length} checks passed"
  exit(failures.zero? ? 0 : 1)
end
