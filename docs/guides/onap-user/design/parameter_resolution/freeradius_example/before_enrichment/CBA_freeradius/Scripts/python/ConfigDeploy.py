#  Copyright (c) 2019 Bell Canada.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

import netconf_constant
from common import ResolutionHelper
from time import sleep 
from netconfclient import NetconfClient
from org.onap.ccsdk.cds.blueprintsprocessor.functions.netconf.executor import \
  NetconfComponentFunction


class ConfigDeploy(NetconfComponentFunction):

  def process(self, execution_request):      
      log = globals()[netconf_constant.SERVICE_LOG]	  
      print(globals())
      rr = ResolutionHelper(self)

      # Get meshed template from DB
      resolution_key = self.getDynamicProperties("resolution-key").asText()
      payload = rr.retrieve_resolved_template_from_database(resolution_key, "userconfig")      
      print(payload)


  def recover(self, runtime_exception, execution_request):
        log.error("Exception in the script {}", runtime_exception)
        print self.addError(runtime_exception.cause.message)
        return None