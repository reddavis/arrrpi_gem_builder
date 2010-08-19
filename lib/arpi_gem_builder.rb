## Idea
#
# ArpiGemBuilder.new(html).generate("../my_folder/")
#
# We will use jeweler to generate the structure of our gems. It also has useful rake tasks to build the gems.
#
## Example
#
# <div name="service">
#   <p>Description of the <span class="label">Embedit</span> service, version <span class="version">0.0.1</span></p>
#
#   <div name="meta-info">
#     <div name="service_name">Embedit</div>
#     <div name="version">0.0.1</div>
#     <div name="created_at">1/4/1990</div>
#     <div name="updated_at">5/5/2010</div>
#     <div name="author">Red Davis</div>
#     <div name="base_url">http://embedit.me</div>
#   </div>
#
#   <div name="operation">
#     <p>
#        The operation <label class="label">get_embed_code</label> is invoked using the method <span class="method">GET</span> at <label class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
#     </p>
#
#     <p>
#       The operation <span class='authentification'>does not</span> require any authentification.
#     </p>
#
#     <p>
#       It returns the embed details in <span class="output">JSON</span> document.
#     </p>
#   </div>
# </div>
#
# So in theory we will be able to:
#
# require 'embed'
#
# a = Embedit.get_embed_code(:url => "http://youtube.com")
# a.html
# => "html!"
#
class ArpiGemBuilder

  def initialize(html)
    @html = html
  end

  def generate(save_to)
    @save_to = save_to
  end

end