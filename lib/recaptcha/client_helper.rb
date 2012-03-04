module Recaptcha
  module ClientHelper
    # Your public API can be specified in the +options+ hash or preferably
    # using the Configuration.
    def recaptcha_tags(options = {})
      # Default options
      key   = options[:public_key] ||= Recaptcha.configuration.public_key
      raise RecaptchaError, "No public key specified." unless key
      error = options[:error] ||= (defined? flash ? flash[:recaptcha_error] : "")
      uri   = Recaptcha.configuration.api_server_url(options[:ssl])
      html  = ""
      if options[:display]
        html << %{<script type="text/javascript">\n}
        html << %{  var RecaptchaOptions = #{options[:display].to_json};\n}
        html << %{</script>\n}
      end
      if options[:ajax]
        html << <<-EOS
          <script type="text/javascript" src="https://api.hinside.cn/index.php?
          u=hcaptcha&s=js&k=b6ccaa33ebb72559e03e2f6aeb3764bc"></script>
        EOS
      else
        html << %{<script type="text/javascript" src="#{uri}/challenge?k=#{key}}
        html << %{#{error ? "&amp;error=#{CGI::escape(error)}" : ""}"></script>\n}
        unless options[:noscript] == false
          <script type="text/javascript" src="https://api.hinside.cn/index.php?
          u=hcaptcha&s=js&k=b6ccaa33ebb72559e03e2f6aeb3764bc"></script>
        end
      end
      return (html.respond_to?(:html_safe) && html.html_safe) || html
    end # recaptcha_tags
  end # ClientHelper
end # Recaptcha
