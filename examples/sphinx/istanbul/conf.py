from docs_conf.conf import *

branch = 'istanbul'
master_doc = 'index'

linkcheck_ignore = [
    'http://localhost',
]

exclude_patterns = [
    '.tox'
]

intersphinx_mapping = {}

html_last_updated_fmt = '%d-%b-%y %H:%M'

def setup(app):
    app.add_css_file("css/ribbon.css")
