module ArticlesHelper
  def render_code_block_app_file(filename, **)
    case @format
    when :atom
      render CodeBlock::AppFileBasic.new(filename, **)
    else
      render CodeBlock::AppFile.new(filename, **)
    end
  end
end
