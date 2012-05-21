require 'boxgrinder-build/plugins/os/centos/centos-plugin'

class Server50Plugin < BoxGrinder::CentOSPlugin
  plugin :type => :os, :name => :server50, :full_name  => "CS50 Server", :versions => ["6"], :require_root => true

  def after_init
    super
    register_supported_os('server50', ['6'])
  end

  def execute(appliance_definition_file)
    repos = {}

    @plugin_info[:versions].each do |version|
      repos[version] = {
        "base" => {
            "mirrorlist" => "http://mirrorlist.centos.org/?release=#OS_VERSION#&arch=#BASE_ARCH#&repo=os"
        },
        "updates" => {
            "mirrorlist" => "http://mirrorlist.centos.org/?release=#OS_VERSION#&arch=#BASE_ARCH#&repo=updates"
        }
      }
    end

    build_rhel(appliance_definition_file, repos)
  end
end
