require 'fileutils'
  class Timing
    def initialize
      @t = Time.new
    end
    def elapsed()
      t = Time.new - @t
      @t=nil
      s = (t%60).to_i.to_s
      m = ((t/60) % 60).to_i.to_s
      h = ((t/3600) % 24).to_i.to_s
      out=''
      out = "#{h} hrs" if h and h.to_i>0
      out += " #{m} mins" if m and m.to_i>0
      out += " #{s} secs" if s and s.to_i>0
      out='0 secs' if out==''
      out.strip
    end
  end
class RapidGet
        attr_reader :ok
      def initialize(user,pass)
        @ok = true
        if !File.exist?('/home/pabloq/.cookies/rapidshare')
                FileUtils.mkdir_p '~/.cookies/'
                puts cookie_command = "wget --save-cookies ~/.cookies/rapidshare --post-data \"login=#{user}&password=#{pass}\" -O - https://ssl.rapidshare.com/cgi-bin/premiumzone.cgi > /dev/null"
                @ok=system(cookie_command)
        end
      end
      def get_file file,here=nil
        if !here
          FileUtils.mkdir_p "~/download/"
          here = '~/download'
        end
        puts cmd = "wget -c --load-cookies ~/.cookies/rapidshare #{file} -P #{here}"
        system(cmd)
      end
        def get_links(file,here=nil)
        puts "*"*40
        puts "Getting links on file #{file}..."
        g = Timing.new
                if File.exist?(file)
                        File.new(file,'r').each{|line|
                                line.strip!
                                if line!=''
                                        puts "*"*40
                                        puts "Get file #{line}..."
                                        t = Timing.new
                                        if get_file(line,here)
                                                puts "File downloaded :D."
                                        else
                                                puts "Error getting the file..."

                                        end
                                        puts "Done in:#{t.elapsed}"
                                end
                        }
                else
                        puts "File doesn't exist."
                end
        puts "*"*40
        puts "Global Time: #{g.elapsed}"
        puts "*"*40
        end
end
