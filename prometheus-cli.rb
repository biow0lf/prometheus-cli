require 'thor'
require 'json'
require 'open-uri'

API_URL = 'http://packages.altlinux.org/api'
BRANCHES_PATH = '/branches'
BUGS_PATH = '/bugs'
SRPMS_PATH = '/srpms'

class App < Thor
  desc 'branches', 'Show branches info'
  def branches
    url = "#{ API_URL }#{ BRANCHES_PATH }"
    data = JSON.parse(open(url).read)

    data.each do |branch|
      puts "ID: #{ branch['id'] }"
      puts "Name: #{ branch['name'] }"
      puts "Srpms count: #{ branch['count'] }"
    end
  end

  desc 'bug ID', 'Show bug ID info'
  def bug(id)
    url = "#{ API_URL }#{ BUGS_PATH }/#{ id }"
    data = JSON.parse(open(url).read)

    puts "Bug info for ID: #{ data['bug_id'] }"
    puts "Description: #{ data['short_desc'] }"
    puts "Status: #{ data['bug_status'] }"
    puts "Resolution: #{ data['resolution'] }" if data['resolution']
    puts "Severity: #{ data['bug_severity'] }"
    puts "Product: #{ data['product'] }"
    puts "Component: #{ data['component'] }"
    puts "Assigned to: #{ data['assigned_to'] }"
    puts "Reported by: #{ data['reporter'] }"
  end

  desc 'srpm NAME', 'Show srpm info for NAME'
  def srpm(name)
    url = "#{ API_URL }#{ SRPMS_PATH }/#{ name }"
    data = JSON.parse(open(url).read)

    puts "Branch: #{ data['branch'] }"
    puts ""
    puts "Name: #{ data['name'] }"
    puts "Version: #{ data['version'] }"
    puts "Release: #{ data['release'] }"
    puts "Epoch: #{ data['epoch'] }" if data['epoch']
    puts ""
    puts "Summary: #{ data['summary'] }"
    puts "License: #{ data['license'] }"
    puts "Group: #{ data['group'] }"
    puts "Url: #{ data['url'] }" if data['url']
    puts ""
    puts "%description\n#{ data['description'] }"
    puts ""
    # TODO: format time
    # "buildtime"=>"2014-10-03T10:54:05.000Z",
    puts "Buildtime: #{ data['buildtime'] }"
    puts "Filename: #{ data['filename'] }"
    puts "Size: #{ data['size'] }"
    puts "MD5: #{ data['md5'] }"
    puts "Repocop status: #{ data['repocop'] }"
    puts ""
    puts "Vendor: #{ data['vendor'] }"
    puts "Distribution: #{ data['distribution'] }"
    puts ""
    # TODO: "builder_id"=>87
    puts "Last builded by: TODO:"
    puts ""
    puts "Last %changelog entry:"
    # TODO: wtf this changelogtime???
    # "changelogtime"=>"1970-01-01T00:33:34.000Z"
    puts "#{ data['changelogtime'] } #{ data['changelogname'] }"
    puts "#{ data['changelogtext'] }"
  end
end

App.start ARGV

