project = "onap"
release = "master"
version = "master"

author = "Open Network Automation Platform"
# yamllint disable-line rule:line-length
copyright = "ONAP. Licensed under Creative Commons Attribution 4.0 International License."

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

branch = 'latest'

intersphinx_mapping = {}
doc_url = 'https://docs.onap.org/projects'
master_doc = 'index'

intersphinx_mapping['onap-aai-aai-common'] = ('{}/onap-aai-aai-common/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-aai-sparky-be'] = ('{}/onap-aai-sparky-be/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-apps'] = ('{}/onap-ccsdk-apps/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-cds'] = ('{}/onap-ccsdk-cds/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-distribution'] = ('{}/onap-ccsdk-distribution/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-features'] = ('{}/onap-ccsdk-features/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-oran'] = ('{}/onap-ccsdk-oran/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-cli'] = ('{}/onap-cli/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-cps'] = ('{}/onap-cps/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-cps-cps-temporal'] = ('{}/onap-cps-cps-temporal/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-cps-ncmp-dmi-plugin'] = ('{}/onap-cps-ncmp-dmi-plugin/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dcaegen2'] = ('{}/onap-dcaegen2/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dmaap-buscontroller'] = ('{}/onap-dmaap-buscontroller/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dmaap-datarouter'] = ('{}/onap-dmaap-datarouter/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dmaap-messagerouter-messageservice'] = ('{}/onap-dmaap-messagerouter-messageservice/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-holmes-engine-management'] = ('{}/onap-holmes-engine-management/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-holmes-rule-management'] = ('{}/onap-holmes-rule-management/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-integration'] = ('{}/onap-integration/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-modeling-etsicatalog'] = ('{}/onap-modeling-etsicatalog/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-modeling-modelspec'] = ('{}/onap-modeling-modelspec/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-msb-apigateway'] = ('{}/onap-msb-apigateway/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-msb-discovery'] = ('{}/onap-msb-discovery/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-msb-java-sdk'] = ('{}/onap-msb-java-sdk/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-msb-swagger-sdk'] = ('{}/onap-msb-swagger-sdk/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-multicloud-framework'] = ('{}/onap-multicloud-framework/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-multicloud-k8s'] = ('{}/onap-multicloud-k8s/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-oom'] = ('{}/onap-oom/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-oom-offline-installer'] = ('{}/onap-oom-offline-installer/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-oom-platform-cert-service'] = ('{}/onap-oom-platform-cert-service/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-optf-has'] = ('{}/onap-optf-has/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-optf-osdf'] = ('{}/onap-optf-osdf/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-osa'] = ('{}/onap-osa/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-policy-parent'] = ('{}/onap-policy-parent/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-sdc'] = ('{}/onap-sdc/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-sdnc-oam'] = ('{}/onap-sdnc-oam/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-so'] = ('{}/onap-so/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-usecase-ui'] = ('{}/onap-usecase-ui/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vfc-nfvo-lcm'] = ('{}/onap-vfc-nfvo-lcm/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vnfsdk-model'] = ('{}/onap-vnfsdk-model/en/%s'.format(doc_url) % branch, None)

html_last_updated_fmt = '%d-%b-%y %H:%M'

def setup(app):
    app.add_css_file("css/ribbon.css")
