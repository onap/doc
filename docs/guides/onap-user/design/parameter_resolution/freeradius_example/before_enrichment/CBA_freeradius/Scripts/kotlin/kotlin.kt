package org.onap.ccsdk.cds.blueprintsprocessor.services.execution.scripts

import com.fasterxml.jackson.databind.node.ObjectNode
import org.onap.ccsdk.cds.blueprintsprocessor.core.api.data.ExecutionServiceInput
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.AbstractComponentFunction
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.AbstractScriptComponentFunction
import org.onap.ccsdk.cds.blueprintsprocessor.services.execution.ComponentFunctionScriptingService

import java.io.ByteArrayInputStream
import java.io.IOException
import java.io.InputStream
import org.apache.sshd.client.SshClient
import org.apache.sshd.client.channel.ClientChannel
import org.apache.sshd.client.future.AuthFuture
import org.apache.sshd.client.future.ConnectFuture
import org.apache.sshd.client.session.ClientSession
import org.apache.sshd.common.future.SshFutureListener
import org.apache.sshd.common.util.io.NoCloseInputStream
import org.apache.sshd.common.util.io.NoCloseOutputStream
import org.onap.ccsdk.cds.blueprintsprocessor.functions.resource.resolution.storedContentFromResolvedArtifactNB
import org.onap.ccsdk.cds.controllerblueprints.core.BluePrintProcessorException
import org.onap.ccsdk.cds.controllerblueprints.core.asListOfString
import org.onap.ccsdk.cds.controllerblueprints.core.utils.JacksonUtils
import org.slf4j.LoggerFactory
import java.io.ByteArrayOutputStream
import java.util.*

open class SampleScriptComponent : AbstractScriptComponentFunction() {

    private val log = LoggerFactory.getLogger(SampleScriptComponent::class.java)!!

    override suspend fun processNB(executionRequest: ExecutionServiceInput) {
        log.info("Hello Kotlin!")
        val resolution_key = getDynamicProperties("resolution-key").asText()
        log.info("resolution_key: $resolution_key")
        val payload = storedContentFromResolvedArtifactNB(resolution_key, "userconfig")
        val payloadObject = JacksonUtils.jsonNode(payload) as ObjectNode
        val freeradius_ip: String = payloadObject.get("freeradius_ip").asText()
        log.info("freeradius_ip: $freeradius_ip")
        val user_config: String = payloadObject.get("user_config").asText()
        log.info("user_config: $user_config")  
        log.info("Waiting 2 minutes for VM to initialize")
        Thread.sleep(120000)		
        val client = SshClient.setUpDefaultClient()
        client.start()
        log.info("SSH Client Service started successfully")
        val session = client.connect("cloud", freeradius_ip, 22).verify(3000).session
        session.addPasswordIdentity("password")
        log.info("SSH Client authenticating...")
        val authFuture = session.auth().verify(3000)
        log.info("SSH client session($session) created")
        log.info("SSH Authenticated: $authFuture.isSuccess()")
        val command="echo '$user_config' | sudo tee -a /etc/freeradius/users"
        log.info("Executing host($session) command($command)")
        val channel = session.createExecChannel(command)
        val outputStream = ByteArrayOutputStream()
        channel!!.out = outputStream
        channel!!.err = outputStream
        channel!!.open().await()
        //val waitMask = channel!!.waitFor(Collections.unmodifiableSet(EnumSet.of(ClientChannelEvent.CLOSED)), 3000)
        //if (waitMask.contains(ClientChannelEvent.TIMEOUT)) {
        //    throw BluePrintProcessorException("Failed to retrieve command result in time: $command")
        //}
        Thread.sleep(3000)
        val exitStatus = channel!!.exitStatus
        //ClientChannel. .validateCommandExitStatusCode(command, exitStatus!!)
        if (channel != null) {
            channel!!.close()
        }
        if (client.isOpen) {
            client.stop()
        }
        log.info(outputStream.toString())
        log.info("SSH Client Service stopped successfully")


    }


    override suspend fun recoverNB(runtimeException: RuntimeException, executionRequest: ExecutionServiceInput) {
    }
}