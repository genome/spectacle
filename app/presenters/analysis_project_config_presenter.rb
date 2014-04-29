class AnalysisProjectConfigPresenter
  def initialize(analysis_project)
    @analysis_project = analysis_project
    @config = read_config_files
  end

  def expected_models
    @config.flat_map { |(_, c)| c['models'].keys }
      .uniq
      .map { |model| model.sub('Genome::Model::','') }
  end

  def config_files_markup
    @config.map do |(file_path, data)|
      [
        File.basename(file_path, '.yml'),
        CodeRay.highlight(data.to_yaml, :yaml).html_safe
      ]
    end
  end

  private
  def get_file_paths
    @file_paths ||= @analysis_project.config_profile_items
      .includes(:allocation, :analysis_menu_item)
      .map { |item| item.file_path }
  end

  def read_config_files
    get_file_paths.map { |path| [path, YAML.load_file(path)] }
  end
end
