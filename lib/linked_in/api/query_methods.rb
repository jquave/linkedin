module LinkedIn
  module Api

    module QueryMethods

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      def company(options = {})
        path = company_path(options)
        simple_query(path, options)
      end
      
      def job_bookmarks(options = {})
        path = job_bookmarks_path(options)
        simple_query(path, options)
      end
      
      def job_suggestions(options = {})
        path = job_suggestions_path(options)
        simple_query(path, options)
      end
      
      def people_search(options = {})
        path = people_search_path(options)
        simple_query(path, options)
      end

      private

        def simple_query(path, options={})
          fields = options.delete(:fields) || LinkedIn.default_profile_fields

          if options.delete(:public)
            path +=":public"
          elsif fields
            path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end
          
          headers = options.delete(:headers) || {}
          params  = options.map { |k,v| "#{k}=#{v}" }.join("&")
          path   += "?#{params}" if not params.empty?

          puts 'Request path: ' + path
          Mash.from_json(get(path, headers))
        end

        def person_path(options)
          path = "/people/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          else
            path += "~"
          end
        end

        def company_path(options)
          path = "/companies/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          elsif name = options.delete(:name)
            path += "universal-name=#{CGI.escape(name)}"
          elsif domain = options.delete(:domain)
            path += "email-domain=#{CGI.escape(domain)}"
          else
            path += "~"
          end
        end
        
        # http://api.linkedin.com/v1/people/~/job-bookmarks
        def job_bookmarks_path(options)
          path = "/people/~/job-bookmarks"
        end
        
        # http://api.linkedin.com/v1/people/~/suggestions/job-suggestions:(jobs)
        def job_suggestions_path(options)
          path = "/people/~/suggestions/job-suggestions"
        end
        
        def people_search_path(options)
          path = "/people-search?"

          if first_name = options.delete(:first_name)
            path += "first-name=#{CGI.escape(first_name)}"

            if last_name = options.delete(:last_name)
              path += "&last-name=#{CGI.escape(last_name)}"
            end
          else
            path += "~"
          end

        end
        
    end

  end
end