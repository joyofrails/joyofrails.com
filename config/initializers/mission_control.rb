# We use route constraints for AdminUser to gate access to the
# MissionControl::Jobs engine
MissionControl::Jobs.http_basic_auth_enabled = false
