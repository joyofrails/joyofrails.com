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

    def self.os_title(os_name)
      case os_name
      when /macos/i
        "macOS"
      when /ipad/i
        "iPad"
      when /ios/i
        "iOS"
      else
        os_name&.titleize || "this platform"
      end
    end

    def self.browser_title(browser_name)
      browser_name&.titleize || "your browser"
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
        "macos"
      when /windows/i
        "windows"
      when /ios/i
        "ios"
      when /android/i
        "android"
      when /linux/i
        "linux"
      else
        "your platform"
      end
    end

    def os_title
      self.class.os_title(os_name)
    end

    def browser_name
      case user_agent_nickname
      when /chrome/i
        "chrome"
      when /firefox/i
        "firefox"
      when /edge/i
        "edge"
      when /safari/i
        "safari"
      else
        "this browser"
      end
    end

    def browser_title
      self.class.browser_title(browser_name)
    end

    def full_version
      nil
    end
  end
end
