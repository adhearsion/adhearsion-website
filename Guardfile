require 'guard/guard'

module ::Guard
  class Docs < ::Guard::Guard
    def run_all
      generate_docs
    end

    def run_on_change(paths)
      puts "Re-generating docs because #{paths} changed"
      generate_docs
    end

    private

    def generate_docs
      puts `rake docs`
    end
  end
end

guard 'docs' do
  watch %r{^docs/source/.+\.(md|html|sh)$}
  watch %r{^docs/output/.+\.(md|html|sh)$}
  watch 'docs/.dexy'
end
