class AnalysisProjectConfigPresenter
  def initialize(analysis_project)
    @analysis_project = analysis_project
    @config = read_config_files
    @formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
    @lexer = Rouge::Lexers::YAML.new
  end

  def expected_models
    @config.flat_map { |(_, _, c, _)| c['models'].present? ? c['models'].keys : [] }
      .uniq
      .map { |model| model.sub('Genome::Model::','') }
  end

  def config_files_markup
    @config.select { |x| x[1].present? }.map do |(id, file_path, data, tags)|
      [
        id,
        File.basename(file_path, '.yml'),
        get_highlighted_markup(data.to_yaml),
        tags
      ]
    end
  end

  private
  def get_file_paths
    @file_paths ||= @analysis_project.config_profile_items
      .includes(:allocation, :analysis_menu_item)
      .map { |item| [item.id, item.file_path] }
  end

  def read_config_files
    get_file_paths.map { |(id, path)| [id, path, load_yaml(path), tag_names(id)] }
  end

  def load_yaml(path)
    YAML.load_file(path) rescue 'Unable to read file'
  end

  def tag_names(item_id)
    @analysis_project.config_profile_items.includes(:tags).select{|x| x.id == item_id }.first.tags.map {|tag| tag.name }
  end

  def get_highlighted_markup(text)
    @formatter.format(@lexer.lex(text)).html_safe
  end
end
