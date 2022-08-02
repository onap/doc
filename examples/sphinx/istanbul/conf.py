project = "onap"
release = "istanbul"
version = "istanbul"

author: "Open Network Automation Platform"
# yamllint disable-line rule:line-length
copyright: "ONAP. Licensed under Creative Commons Attribution 4.0 International License."

pygments_style = "sphinx"
html_theme = "sphinx_rtd_theme"
html_theme_options = {
  "style_nav_header_background": "white",
  "sticky_navigation": "False" }
html_logo = "_static/logo_onap_2017.png"
html_favicon = "_static/favicon.ico"
html_static_path = ["_static"]
html_show_sphinx = False

extensions = [
    'sphinx.ext.intersphinx','sphinxcontrib.blockdiag',
    'sphinxcontrib.seqdiag', 'sphinxcontrib.swaggerdoc', 'sphinx.ext.graphviz']

#
# Map to 'latest' if this file is used in 'latest' (master) 'doc' branch.
# Change to {releasename} after you have created the new 'doc' branch.
#

branch = 'istanbul'

intersphinx_mapping = {}
doc_url = 'https://docs.onap.org/projects'
master_doc = 'index'

#
# Example:
# intersphinx_mapping['onap-aai-aai-common'] = ('{}/onap-aai-aai-common/en/%s'.format(doc_url) % branch, None)
#

html_last_updated_fmt = '%d-%b-%y %H:%M'

def setup(app):
    app.add_css_file("css/ribbon.css")