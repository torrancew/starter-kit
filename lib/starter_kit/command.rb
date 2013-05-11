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

  def module_name(opts={})
    opts     = { :camel_case => false, :first => :lower }.merge(opts)
    mod_name = File.basename(name)

    if opts[:camel_case]
      mod_name = mod_name.gsub(/[-\s_]/, ' ').strip.split.map { |w| w[0].upcase + w[1..-1] }.join()
    end

    mod_name[0].downcase! unless opts[:first] == :upper
    return mod_name
  end

  option ['-a', '--author'],   'AUTHOR', 'The author of this module'
  option ['-S', '--source'],   'URL',    'The URL to the project source code'
  option ['-H', '--homepage'], 'URL',    'The URL to the project homepage'

  option ['-s', '--summary'], 'SUMMARY', 'The module summary'
  def default_summary
    return "The #{module_name} module"
  end

  option ['-D', '--description'], 'DESC', 'The module description'
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

  option ['-p', '--prefix'], 'PREFIX', 'A string to prefix the module directory with'
  def module_path
    path = ((prefix.nil? or prefix.empty?) ? module_name : "#{prefix}-#{module_name}")
    return File.expand_path(File.join(chdir, path))
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
    unless File.exist?(module_path)
      puts "Creating #{module_path}"
      FileUtils.mkdir_p(module_path)
    end
  end

  def install_template(t, path)
    file_loc  = File.dirname(t).gsub('module_name', module_name)
    file_name = File.basename(t, '.erb').gsub('module_name', module_name)
    dest_file = File.expand_path(File.join(path, file_loc, file_name))
    dest_dir  = File.dirname(dest_file)

    unless File.exist?(dest_dir) and File.directory?(dest_dir)
      puts "Creating #{dest_dir}"
      FileUtils.mkdir_p(dest_dir)
    end

    puts "Generating #{dest_file}"
    File.open(dest_file, 'w'){ |f| f.write(template(t)) }
  end

  def execute
    if File.exist?(module_path)
      puts "Error: Module already exists at #{module_path}"
    else
      create_module_dir
      templates.sort.each { |t| install_template(t, module_path) }
    end
  end
end

