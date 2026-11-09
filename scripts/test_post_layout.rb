#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'digest'
require 'fileutils'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'yaml'
require_relative 'lib/post_layout' if File.file?(File.join(__dir__, 'lib/post_layout.rb'))

ROOT = File.expand_path('..', __dir__)

def assert(condition, message)
  raise message unless condition
end

def with_project
  Dir.mktmpdir('ladydebug-post-layout-') do |root|
    FileUtils.cp_r(File.join(ROOT, 'scripts'), root)
    yield root, File.join(root, 'content/docs')
  end
end

def write_post(path, title:, slug:, body: '', language: nil)
  FileUtils.mkdir_p(File.dirname(path))
  metadata = { 'title' => title, 'date' => '2023-02-04', 'slug' => slug, 'draft' => true }
  metadata['lang'] = language if language
  File.write(path, metadata.to_yaml + "---\n\n#{body}\n")
end

def metadata(path)
  YAML.safe_load(File.read(path).split('---', 3)[1], permitted_classes: [Date, Time])
end

def snapshot(root)
  Dir.glob(File.join(root, '**/*'), File::FNM_DOTMATCH).select { |path| File.file?(path) }
     .to_h { |path| [path.delete_prefix(root), Digest::SHA256.file(path).hexdigest] }
end

checks = {}
checks['paths use year, Portuguese month without a numeric prefix, day-month and descriptive filenames'] = lambda do
  info = { 'date' => '2023-02-04T00:35:15Z', 'slug' => 'meu-estudo' }
  assert(PostLayout.post_relative_path(info, 'index.md') == '2023/fevereiro/04-02/meu-estudo.md', 'Incorrect Portuguese path')
  assert(PostLayout.post_relative_path(info, 'index.en.md') == '2023/fevereiro/04-02/meu-estudo.en.md', 'Incorrect English path')
end
checks['the creator supports historical dates and escapes YAML titles and tags'] = lambda do
  with_project do |root, posts|
    title = 'Uma análise: "ação"'
    out, err, status = Open3.capture3(RbConfig.ruby, File.join(root, 'scripts/new_post.rb'), '--date', '2023-02-04', title, 'testes, desempenho', chdir: Dir.tmpdir)
    assert(status.success?, "Creator failed: #{out}#{err}")
    file = File.join(posts, '2023/fevereiro/04-02/uma-analise-acao.md')
    data = metadata(file)
    assert(data['title'] == title && data['tags'] == %w[testes desempenho] && data['draft'], 'Invalid front matter')
    assert(File.directory?(File.join(posts, '2023/fevereiro/images')), 'Month images directory missing')
  end
end
checks['multiple posts on one day coexist and duplicate names never overwrite content'] = lambda do
  with_project do |root, posts|
    script = File.join(root, 'scripts/new_post.rb')
    %w[Primeiro Segundo].each do |title|
      _, _, status = Open3.capture3(RbConfig.ruby, script, '--date', '2023-02-04', title, '')
      assert(status.success?, 'Different posts must coexist')
    end
    before = snapshot(posts)
    _, _, status = Open3.capture3(RbConfig.ruby, script, '--date', '2023-02-04', 'Primeiro', '')
    assert(!status.success? && before == snapshot(posts), 'Duplicate post overwrote existing files')
  end
end
checks['invalid dates are rejected before creating directories'] = lambda do
  with_project do |root, posts|
    _, _, status = Open3.capture3(RbConfig.ruby, File.join(root, 'scripts/new_post.rb'), '--date', '2023-02-30', 'Inválido', '')
    assert(!status.success? && !File.exist?(posts), 'Invalid date created content')
  end
end
checks['migration preserves languages, published URLs, image bytes and date metadata'] = lambda do
  with_project do |root, posts|
    a = File.join(posts, '2023/fevereiro/primeiro')
    b = File.join(posts, '2023/fevereiro/segundo')
    write_post(File.join(a, 'index.md'), title: 'Primeiro', slug: 'primeiro', body: '![Foto](image.png)')
    write_post(File.join(a, 'index.en.md'), title: 'First', slug: 'primeiro', body: '![Photo](image.png)')
    write_post(File.join(b, 'index.md'), title: 'Segundo', slug: 'segundo', body: '![Outra](image.png)')
    File.write(File.join(a, 'image.png'), 'first-image-bytes')
    File.write(File.join(b, 'image.png'), 'second-image-bytes')
    PostLayout::Migration.new(posts_root: posts, repo_root: root).apply!
    expected = File.join(posts, '2023/fevereiro/04-02/primeiro.md')
    english = expected.sub(/\.md$/, '.en.md')
    assert(metadata(expected)['url'] == '/docs/2023/fevereiro/primeiro/', 'Portuguese URL changed')
    assert(metadata(english)['url'] == '/en/docs/2023/fevereiro/primeiro/', 'English URL changed')
    assert(metadata(expected)['date'] == '2023-02-04', 'Original date changed')
    images = Dir.glob(File.join(posts, '2023/fevereiro/images/*'))
    assert(images.map { |p| File.binread(p) }.sort == %w[first-image-bytes second-image-bytes], 'Images overwritten or lost')
    [expected, english].each do |path|
      src = File.read(path)[/!\[[^\]]*\]\(([^)]+)\)/, 1]
      assert(src.start_with?('../images/') && File.file?(File.expand_path(src, File.dirname(path))), 'Relative image path is broken')
    end
  end
end
checks['migration preserves image captions, queries and fragments'] = lambda do
  with_project do |root, posts|
    directory = File.join(posts, '2023/fevereiro/exemplo')
    write_post(File.join(directory, 'index.md'), title: 'Exemplo', slug: 'exemplo', body: '![Foto](image.png?download=1#preview "Legenda original")')
    File.write(File.join(directory, 'image.png'), 'image-bytes')
    PostLayout::Migration.new(posts_root: posts, repo_root: root).apply!
    migrated = File.read(File.join(posts, '2023/fevereiro/04-02/exemplo.md'))
    assert(migrated.include?('![Foto](../images/exemplo--image.png?download=1#preview "Legenda original")'), 'Image caption, query or fragment changed')
  end
end
checks['validation rejects numbered month folders'] = lambda do
  with_project do |_root, posts|
    write_post(File.join(posts, '2023/fevereiro/04-02/exemplo.md'), title: 'Exemplo', slug: 'exemplo')
    PostLayout.validate!(posts)
    image = File.join(posts, '2023/02-fevereiro/images/foto.png')
    FileUtils.mkdir_p(File.dirname(image))
    File.write(image, 'image-bytes')
    rejected = false
    begin
      PostLayout.validate!(posts)
    rescue ArgumentError
      rejected = true
    end
    assert(rejected, 'An incorrectly numbered month was accepted')
  end
end
checks['migration removes month prefixes without renaming shared images'] = lambda do
  with_project do |root, posts|
    source = File.join(posts, '2023/02-fevereiro/04-02/exemplo.md')
    write_post(source, title: 'Exemplo', slug: 'exemplo', body: '![Foto](../images/exemplo--foto.png)')
    images = File.join(posts, '2023/02-fevereiro/images')
    FileUtils.mkdir_p(images)
    File.write(File.join(images, 'exemplo--foto.png'), 'image-bytes')
    PostLayout::Migration.new(posts_root: posts, repo_root: root).apply!
    target = File.join(posts, '2023/fevereiro/04-02/exemplo.md')
    assert(File.file?(target), 'Month prefix was not removed')
    assert(File.read(target).include?('![Foto](../images/exemplo--foto.png)'), 'Shared image name changed')
    assert(File.read(File.join(posts, '2023/fevereiro/images/exemplo--foto.png')) == 'image-bytes', 'Shared image was lost')
  end
end
checks['dry runs leave every source file untouched and migration is idempotent'] = lambda do
  with_project do |root, posts|
    write_post(File.join(posts, '2023/fevereiro/antigo.md'), title: 'Antigo', slug: 'antigo')
    before = snapshot(posts)
    migration = PostLayout::Migration.new(posts_root: posts, repo_root: root)
    migration.plan
    assert(before == snapshot(posts), 'Planning modified files')
    migration.apply!
    after = snapshot(posts)
    PostLayout::Migration.new(posts_root: posts, repo_root: root).apply!
    assert(after == snapshot(posts), 'Running migration twice changed content')
  end
end
checks['destination collisions abort before moving or deleting any file'] = lambda do
  with_project do |root, posts|
    %w[a b].each { |folder| write_post(File.join(posts, "2023/fevereiro/#{folder}/index.md"), title: folder, slug: 'mesmo-post') }
    before = snapshot(posts)
    failed = false
    begin
      PostLayout::Migration.new(posts_root: posts, repo_root: root).apply!
    rescue ArgumentError
      failed = true
    end
    assert(failed && before == snapshot(posts), 'Collision did not safely abort')
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
