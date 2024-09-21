module Pwa
  class NamedInstallationInstructions
    def self.user_agent_glob
      Dir[Rails.root.join("app", "views", "pwa", "installation_instructions", "user_agents", "*.html.erb")]
    end

    def self.user_agent_nicknames
      @user_agent_nicknames ||= user_agent_glob.map do |path|
        File.basename(path, ".html.erb").sub(/^_/, "")
      end
    end

    def self.partial_name(user_agent_nickname)
      "pwa/installation_instructions/user_agents/#{user_agent_nickname}"
    end

    def self.find(user_agent_nickname)
      raise ActiveRecord::RecordNotFound unless user_agent_nicknames.include?(user_agent_nickname)

      new(user_agent_nickname)
    end

    attr_reader :user_agent_nickname

    def initialize(user_agent_nickname)
      @user_agent_nickname = user_agent_nickname
    end

    def partial_name
      self.class.partial_name(user_agent_nickname)
    end

    def os_name
      case user_agent_nickname
      when /macos/i
        "macOS"
      when /ipados/i
        "iPadOS"
      when /windows/i
        "Windows"
      when /ios/i
        "iOS"
      when /android/i
        "Android"
      when /linux/i
        "Linux"
      else
        "your platform"
      end
    end

    def browser_name
      case user_agent_nickname
      when /chrome/i
        "Chrome"
      when /firefox/i
        "Firefox"
      when /edge/i
        "Microsoft Edge"
      when /safari/i
        "Safari"
      else
        "this browser"
      end
    end

    def full_version
      nil
    end
  end
end
