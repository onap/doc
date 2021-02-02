from docs_conf.conf import *

branch = 'guilin'
doc_url = 'https://docs.onap.org/projects'
master_doc = 'index'

linkcheck_ignore = [
    'http://localhost',
]

intersphinx_mapping = {}

# Guilin
intersphinx_mapping['onap-aai-aai-common'] = ('{}/onap-aai-aai-common/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-aai-event-client'] = ('{}/onap-aai-event-client/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-aai-sparky-be'] = ('{}/onap-aai-sparky-be/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-cds'] = ('{}/onap-ccsdk-cds/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-apps'] = ('{}/onap-ccsdk-apps/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-features'] = ('{}/onap-ccsdk-features/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-distribution'] = ('{}/onap-ccsdk-distribution/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-oran'] = ('{}/onap-ccsdk-oran/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-clamp'] = ('{}/onap-clamp/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-cli'] = ('{}/onap-cli/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dcaegen2'] = ('{}/onap-dcaegen2/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dmaap-messagerouter-messageservice'] = ('{}/onap-dmaap-messagerouter-messageservice/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dmaap-buscontroller'] = ('{}/onap-dmaap-buscontroller/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dmaap-datarouter'] = ('{}/onap-dmaap-datarouter/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-externalapi-nbi'] = ('{}/onap-externalapi-nbi/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-holmes-engine-management'] = ('{}/onap-holmes-engine-management/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-holmes-rule-management'] = ('{}/onap-holmes-rule-management/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-integration'] = ('{}/onap-integration/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-modeling-etsicatalog'] = ('{}/onap-modeling-etsicatalog/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-modeling-modelspec'] = ('{}/onap-modeling-modelspec/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-multicloud-framework'] = ('{}/onap-multicloud-framework/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-msb-apigateway'] = ('{}/onap-msb-apigateway/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-policy-parent'] = ('{}/onap-policy-parent/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-portal'] = ('{}/onap-portal/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-oom'] = ('{}/onap-oom/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-oom-platform-cert-service'] = ('{}/onap-oom-platform-cert-service/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-optf-cmso'] = ('{}/onap-optf-cmso/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-optf-osdf'] = ('{}/onap-optf-osdf/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-optf-has'] = ('{}/onap-optf-has/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-sdc-sdc-workflow-designer'] = ('{}/onap-sdc-sdc-workflow-designer/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-sdc-sdc-tosca'] = ('{}/onap-sdc-sdc-tosca/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-sdc-sdc-distribution-client'] = ('{}/onap-sdc-sdc-distribution-client/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-sdc-sdc-docker-base'] = ('{}/onap-sdc-sdc-docker-base/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-sdc'] = ('{}/onap-sdc/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-sdnc-oam'] = ('{}/onap-sdnc-oam/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-so'] = ('{}/onap-so/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-usecase-ui'] = ('{}/onap-usecase-ui/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vfc-nfvo-lcm'] = ('{}/onap-vfc-nfvo-lcm/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vid'] = ('{}/onap-vid/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vnfsdk-model'] = ('{}/onap-vnfsdk-model/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vnfrqts-requirements'] = ('{}/onap-vnfrqts-requirements/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vvp-documentation'] = ('{}/onap-vvp-documentation/en/%s'.format(doc_url) % branch, None)

# Frankfurt
branch = 'frankfurt'
intersphinx_mapping['onap-appc'] = ('{}/onap-appc/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-appc-deployment'] = ('{}/onap-appc-deployment/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-logging-analytics'] = ('{}/onap-logging-analytics/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-music'] = ('{}/onap-music/en/%s'.format(doc_url) % branch, None)

# Latest
branch = 'latest'
intersphinx_mapping['onap-aaf-authz'] = ('{}/onap-aaf-authz/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-aaf-sms'] = ('{}/onap-aaf-sms/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-aai-esr-gui'] = ('{}/onap-aai-esr-gui/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-aai-esr-server'] = ('{}/onap-aai-esr-server/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-dashboard'] = ('{}/onap-ccsdk-dashboard/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-ccsdk-platform-plugins'] = ('{}/onap-ccsdk-platform-plugins/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-dmaap-dbcapi'] = ('{}/onap-dmaap-dbcapi/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-logging-analytics'] = ('{}/onap-logging-analytics/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-logging-analytics-pomba-pomba-audit-common'] = ('{}/onap-logging-analytics-pomba-pomba-audit-common/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-modeling-toscaparsers'] = ('{}/onap-modeling-toscaparsers/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-msb-discovery'] = ('{}/onap-msb-discovery/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-msb-java-sdk'] = ('{}/onap-msb-java-sdk/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-msb-swagger-sdk'] = ('{}/onap-msb-swagger-sdk/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-multicloud-azure'] = ('{}/onap-multicloud-azure/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-multicloud-k8s'] = ('{}/onap-multicloud-k8s/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-music-distributed-kv-store'] = ('{}/onap-music-distributed-kv-store/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-oom-offline-installer'] = ('{}/onap-oom-offline-installer/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-oparent-cia'] = ('{}/onap-oparent-cia/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-osa'] = ('{}/onap-osa/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-so-libs'] = ('{}/onap-so-libs/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vfc-nfvo-driver-vnfm-svnfm'] = ('{}/onap-vfc-nfvo-driver-vnfm-svnfm/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vnfrqts-guidelines'] = ('{}/onap-vnfrqts-guidelines/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vnfrqts-testcases'] = ('{}/onap-vnfrqts-testcases/en/%s'.format(doc_url) % branch, None)
intersphinx_mapping['onap-vnfrqts-usecases'] = ('{}/onap-vnfrqts-usecases/en/%s'.format(doc_url) % branch, None)

linkcheck_ignore = [
   'about:config',
   # this URL is not directly reachable and must be configured in the system hosts file.
   'https://portal.api.simpledemo.onap.org:30225/ONAPPORTAL/login.htm',
   # anchor issues
   'https://docs.onap.org/projects/onap-integration/en/guilin/docs_usecases_release.html#.*',
   'https://docs.linuxfoundation.org/docs/communitybridge/easycla/contributors/contribute-to-a-gerrit-project#.*',
   'https://docs.onap.org/projects/onap-integration/en/guilin/docs_robot.html#docs-robot',
   'https://docs.onap.org/projects/onap-integration/en/guilin/docs_usecases_release.html#docs-usecases-release',
   'https://docs.onap.org/projects/onap-integration/en/guilin/docs_usecases.html#docs-usecases',
   'https://docs.onap.org/projects/onap-integration/en/guilin/usecases/release_non_functional_requirements.html#release-non-functional-requirements',
]


html_last_updated_fmt = '%d-%b-%y %H:%M'

def setup(app):
    app.add_css_file("css/ribbon.css")


from docutils.parsers.rst import directives

needs_extra_options = {
    "target": directives.unchanged,
    "keyword": directives.unchanged,
    "introduced": directives.unchanged,
    "updated": directives.unchanged,
    "impacts": directives.unchanged,
    "validation_mode": directives.unchanged,
    "validated_by": directives.unchanged,
    "test": directives.unchanged,
    "test_case": directives.unchanged,
    "test_file": directives.unchanged,
    "notes": directives.unchanged,
}

needs_id_regex = "^[A-Z0-9]+-[A-Z0-9]+"
needs_id_required = True
needs_title_optional = True

needs_template_collapse = """
.. _{{id}}:

{% if hide == false -%}
.. role:: needs_tag
.. role:: needs_status
.. role:: needs_type
.. role:: needs_id
.. role:: needs_title

.. rst-class:: need
.. rst-class:: need_{{type_name}}

.. container:: need

    `{{id}}` - {{content|indent(4)}}

    .. container:: toggle

        .. container:: header

            Details

{% if status and  status|upper != "NONE" and not hide_status %}        | status: :needs_status:`{{status}}`{% endif %}
{% if tags and not hide_tags %}        | tags: :needs_tag:`{{tags|join("` :needs_tag:`")}}`{% endif %}
{% if keyword %}        | keyword: `{{keyword}}` {% endif %}
{% if target %}        | target: `{{target}}` {% endif %}
{% if introduced %}        | introduced: `{{introduced}}` {% endif %}
{% if updated %}        | updated: `{{updated}}` {% endif %}
{% if impacts %}        | impacts: `{{impacts}}` {% endif %}
{% if validation_mode %}        | validation mode: `{{validation_mode}}` {% endif %}
{% if validated_by %}        | validated by: `{{validated_by}}` {% endif %}
{% if test %}        | test: `{{test}}` {% endif %}
{% if test_case %}        | test case: {{test_case}} {% endif %}
{% if test_file %}        | test file: `{{test_file}}` {% endif %}
{% if notes %}        | notes: `{{notes}}` {% endif %}
        | children: :need_incoming:`{{id}}`
        | parents: :need_outgoing:`{{id}}`
{% endif -%}
"""
