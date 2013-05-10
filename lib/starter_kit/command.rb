require 'erb'
require 'clamp'
require 'fileutils'
require 'starter_kit/version'
require 'starter_kit/namespace'

class StarterKit::Command < Clamp::Command
  BASE_TEMPLATE_DIR = File.expand_path('../../../templates', __FILE__)

  public
  def class_name
    return self.class.to_s.gsub(/^.*::/, '').downcase
  end

  def get_binding
    binding
  end

  def module_name
    File.basename(name)
  end

  option ['-a', '--author'],      'AUTHOR',  'The author of this module'
  option ['-S', '--source'],      'URL',     'The URL to the project source code'
  option ['-H', '--homepage'],    'URL',     'The URL to the project homepage'

  option ['-s', '--summary'],     'SUMMARY', 'The module summary'
  def default_summary
    return "The #{module_name} module"
  end

  option ['-D', '--description'], 'DESC',    'The module description'
  def default_description
    summary
  end

  option ['-t', '--template-dir'], 'DIR', 'The template directory for this module'
  def default_template_dir
    return File.join(BASE_TEMPLATE_DIR, class_name)
  end

  option ['-C', '--chdir'], 'DIR', 'The directory to create the module in'
  def default_chdir
    File.dirname(File.expand_path(File.join(Dir.pwd, name)))
  end

  def module_path
    File.expand_path(File.join(chdir, module_name))
  end

  def templates
    return Dir["#{template_dir}/**/*.erb"].map{ |f| f.gsub(%r{^#{template_dir}/}, '') }
  end

  def template(t)
    tmpl    = File.join(template_dir, t)
    src_dir = File.dirname(tmpl)

    return nil unless File.exist?(src_dir) and File.directory?(src_dir) and File.exist?(tmpl)
    return ERB.new(File.read(tmpl)).result(get_binding)
  end

  def create_module_dir
    FileUtils.mkdir_p(module_path) unless File.exist?(module_path)
  end

  def install_template(t, path)
    dest_file = File.expand_path(File.join(path, File.dirname(t), File.basename(t, '.erb')))
    dest_dir  = File.dirname(dest_file)

    unless File.exist?(dest_dir) and File.directory?(dest_dir)
      puts "Creating #{dest_dir}"
      FileUtils.mkdir_p(dest_dir)
    end

    puts "Generating #{dest_file}"
    File.open(dest_file, 'w'){ |f| f.write(template(t)) }
  end

  def execute
    unless File.exist?(module_path)
      create_module_dir
      templates.each { |t| install_template(t, module_path) }
    else
      puts "Error: Module already exists at #{module_path}"
    end
  end
end

