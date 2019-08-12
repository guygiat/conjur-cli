#
# Copyright (C) 2017 Conjur Inc
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class Conjur::Command::Enable < Conjur::Command
  desc "Enable integrations"
  command :enable do |integration|
    integration.desc "Enable jenkins integration"
    integration.command :jenkins do |c|
      c.arg_name "host"
      c.desc "Host name for policy"
      c.flag [:host]

      c.action do |global_options,options,args|
        host = options[:host]
        policy_id = 'root'
        filename = 'integrations/jenkins.yml'
        require 'open-uri'
        file = open(filename).read
        policy = file.gsub("<HOST>", host)
        
        method = Conjur::API::POLICY_METHOD_POST
        result = api.load_policy policy_id, policy, method: method
        $stderr.puts "Loaded policy '#{policy_id}'"
        puts JSON.pretty_generate(result)
      end

    integration.desc "Enable ansible integration"
    integration.command :ansible do |c|
      c.arg_name "host"
      c.desc "Host name for policy"
      c.flag [:host]
  
      c.action do |global_options,options,args|
        host = options[:host]
        policy_id = 'root'
        filename = 'integrations/ansible.yml'
        require 'open-uri'
        file = open(filename).read
        policy = file.gsub("<HOST>", host)
        
        method = Conjur::API::POLICY_METHOD_POST
        result = api.load_policy policy_id, policy, method: method
        $stderr.puts "Loaded policy '#{policy_id}'"
        puts JSON.pretty_generate(result)
      end
    end
    end
  end
end