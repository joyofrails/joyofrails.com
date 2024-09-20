module Pwa
  class UserAgentInstallationInstructions
    delegate :full_version, to: :@device_detector

    def initialize(user_agent)
      @device_detector = DeviceDetector.new(user_agent)
    end

    def user_agent_nickname
      "#{installation_os}_#{installation_browser}"
    end

    def partial_name
      return "desktop_firefox" if installation_browser == "firefox" && desktop?
      return "unsupported" if installation_os == "unsupported" || installation_browser == "unsupported"

      Pwa::NamedInstallationInstructions.partial_name(user_agent_nickname)
    end

    def desktop?
      @device_detector.device_type == "desktop"
    end

    def os_name
      @device_detector.os_name
    end

    def os_title
      Pwa::NamedInstallationInstructions.os_title(os_name)
    end

    def browser_name
      @device_detector.name
    end

    def browser_title
      Pwa::NamedInstallationInstructions.browser_title(browser_name)
    end

    private

    def installation_os
      case os_name
      when /ios/i
        "ios"
      when /android/i
        "android"
      when /mac/i
        "macos"
      when /windows/i
        "windows"
      else
        "unsupported"
      end
    end

    def installation_browser
      case browser_name
      when /chrome|chromium|crios/i
        "chrome"
      when /firefox|fxios/i
        "firefox"
      when /edg/i
        "edge"
      when /safari/i
        "safari"
      else
        "unsupported"
      end
    end
  end
end
