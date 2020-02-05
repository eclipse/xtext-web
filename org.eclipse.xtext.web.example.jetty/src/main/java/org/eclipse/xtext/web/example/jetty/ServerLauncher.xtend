/*******************************************************************************
 * Copyright (c) 2015 itemis AG (http://www.itemis.eu) and others.
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************/
package org.eclipse.xtext.web.example.jetty

import java.net.InetSocketAddress
import org.eclipse.jetty.annotations.AnnotationConfiguration
import org.eclipse.jetty.rewrite.handler.RewriteHandler
import org.eclipse.jetty.rewrite.handler.RewriteRegexRule
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.server.handler.HandlerList
import org.eclipse.jetty.server.handler.ResourceHandler
import org.eclipse.jetty.util.log.Slf4jLog
import org.eclipse.jetty.webapp.MetaInfConfiguration
import org.eclipse.jetty.webapp.WebAppContext
import org.eclipse.jetty.webapp.WebInfConfiguration
import org.eclipse.jetty.webapp.WebXmlConfiguration

class ServerLauncher {

	def static void main(String[] args) {
		val server = new Server(new InetSocketAddress('localhost', 8080))
		server.handler = new RewriteHandler => [
			addRule(new RewriteRegexRule => [
				regex = "/xtext/@xtext-version-placeholder@/(.*)"
				replacement = "/xtext/$1"
				terminating = false
			])
			handler = new HandlerList => [
				handlers = #[
					new ResourceHandler => [
						
						resourceBase = 'src/main/webapp'
						welcomeFiles = #['index.html']
					],
					new ResourceHandler => [
						resourceBase = '../org.eclipse.xtext.web/src/main/css'
					],
					new WebAppContext => [
						resourceBase = '../org.eclipse.xtext.web/src/main/js'
						contextPath = '/'
						configurations = #[
							new AnnotationConfiguration,
							new WebXmlConfiguration,
							new WebInfConfiguration,
							new MetaInfConfiguration
						]
						setAttribute(WebInfConfiguration.CONTAINER_JAR_PATTERN,
							".*/org\\.eclipse\\.xtext\\.web.*,.*/org.webjars.*")
					]
					
				]
			]
		]
		val log = new Slf4jLog(ServerLauncher.name)
		try {
			server.start
			log.info('Press enter to stop the server...')
			new Thread[
		    	val key = System.in.read
		    	server.stop
		    	if (key == -1)
		    		log.warn('The standard input stream is empty.')
		    ].start
			server.join
		} catch (Exception exception) {
			log.warn(exception.message)
			System.exit(1)
		}
	}

}