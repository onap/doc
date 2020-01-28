from docs_conf.conf import *

branch = 'latest'
master_doc = 'index'

linkcheck_ignore = [
    'http://localhost',
]

intersphinx_mapping = {}

html_last_updated_fmt = '%d-%b-%y %H:%M'

def setup(app):
    app.add_stylesheet("css/ribbon_onap.css")

##language = None
#keep_warnings = True
#todo_include_todos = True
#
##html_static_path = ['_static']
#html_show_sphinx = False
#htmlhelp_basename = 'ONAPdoc'
#latex_elements = {
#}
#latex_documents = [
#  (master_doc, 'ONAP.tex', u'ONAP Documentation',
#   u'ONAP Contributors', 'manual'),
#]
#epub_exclude_files = ['search.html']
#Uman_pages = [
#    (master_doc, 'onap', u'ONAP Documentation',
#     [author], 1)
#]
#texinfo_documents = [
#  (master_doc, 'ONAP', u'ONAP Documentation',
#   author, 'ONAP', 'Open Network Automation Platform',
#   'Platform'),
#]
#epub_title = project
#epub_author = author
#epub_publisher = author
#epub_copyright = copyright
#from docutils.parsers.rst import directives
#needs_extra_options = {
#    "target": directives.unchanged,
#    "keyword": directives.unchanged,
#    "introduced": directives.unchanged,
#    "updated": directives.unchanged,
#    "impacts": directives.unchanged,
#    "validation_mode": directives.unchanged,
#    "validated_by": directives.unchanged,
#    "test": directives.unchanged,
#    "test_case": directives.unchanged,
#    "test_file": directives.unchanged,
#    "notes": directives.unchanged,
#}
#
#needs_id_regex = "^[A-Z0-9]+-[A-Z0-9]+"
#needs_id_required = True
#needs_title_optional = True
#needs_template_collapse = """
#.. _{{id}}:
#
#{% if hide == false -%}
#.. role:: needs_tag
#.. role:: needs_status
#.. role:: needs_type
#.. role:: needs_id
#.. role:: needs_title
#
#.. rst-class:: need
#.. rst-class:: need_{{type_name}}
#
#.. container:: need
#
#    `{{id}}` - {{content|indent(4)}}
#
#    .. container:: toggle
#
#        .. container:: header
#
#            Details
#
#{% if status and  status|upper != "NONE" and not hide_status %}        | status: :needs_status:`{{status}}`{% endif %}
#{% if tags and not hide_tags %}        | tags: :needs_tag:`{{tags|join("` :needs_tag:`")}}`{% endif %}
#{% if keyword %}        | keyword: `{{keyword}}` {% endif %}
#{% if target %}        | target: `{{target}}` {% endif %}
#{% if introduced %}        | introduced: `{{introduced}}` {% endif %}
#{% if updated %}        | updated: `{{updated}}` {% endif %}
#{% if impacts %}        | impacts: `{{impacts}}` {% endif %}
#{% if validation_mode %}        | validation mode: `{{validation_mode}}` {% endif %}
#{% if validated_by %}        | validated by: `{{validated_by}}` {% endif %}
#{% if test %}        | test: `{{test}}` {% endif %}
#{% if test_case %}        | test case: {{test_case}} {% endif %}
#{% if test_file %}        | test file: `{{test_file}}` {% endif %}
#{% if notes %}        | notes: `{{notes}}` {% endif %}
#        | children: :need_incoming:`{{id}}`
#        | parents: :need_outgoing:`{{id}}`
#{% endif -%}
#"""
#
#
