/*******************************************************************************
 * Copyright (c) 2015, 2017 itemis AG (http://www.itemis.eu) and others.
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************/
package org.eclipse.xtext.web.server.test

import org.eclipse.xtext.formatting.ILineSeparatorInformation
import org.eclipse.xtext.web.example.statemachine.StatemachineRuntimeModule
import org.eclipse.xtext.web.server.formatting.FormattingResult
import org.eclipse.xtext.web.server.test.AbstractWebServerTest.TestLineSeparatorInformation
import org.eclipse.xtext.web.server.test.languages.formatting.StatemachineFormatter
import org.junit.Test

import static org.junit.Assert.*

class Formatting1Test extends AbstractWebServerTest {
	
	override protected getRuntimeModule() {
		new StatemachineRuntimeModule {
			override bindIFormatter2() {
				null
			}
			override bindIFormatter() {
				StatemachineFormatter
			}
			def Class<? extends ILineSeparatorInformation> bindILineSeparatorInformation() {
				TestLineSeparatorInformation
			}
		}
	}

	@Test def testFormatFile() {
		val file = createFile('/* bla */ output signal x state foo set x = true end')
		val format = getService(#{'serviceType' -> 'format', 'resource' -> file.name})
		assertTrue(format.hasSideEffects)
		val result = format.service.apply() as FormattingResult
		val String expectedResult = '''
			FormattingResult [
			  stateId = "-7fffffff"
			  formattedText = "output signal x\nstate foo\n	set x = true\nend"
			  replaceRegion = [10:42]
			]'''
		assertEquals(expectedResult, result.toString)
	}
	
	@Test def testFormatSelection() {
		val file = createFile('/* bla */ output signal x state foo set x = true end')
		val format = getService(#{
				'serviceType' -> 'format',
				'selectionStart' -> '26',
				'selectionEnd' -> '52',
				'resource' -> file.name
			})
		assertTrue(format.hasSideEffects)
		val result = format.service.apply() as FormattingResult
		val String expectedResult = '''
			FormattingResult [
			  stateId = "-7fffffff"
			  formattedText = "state foo\n	set x = true\nend"
			  replaceRegion = [26:26]
			]'''
		assertEquals(expectedResult, result.toString)
	}
	
}
