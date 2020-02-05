/*******************************************************************************
 * Copyright (c) 2015, 2017 itemis AG (http://www.itemis.eu) and others.
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************/
package org.eclipse.xtext.web.server.test

import org.eclipse.xtext.web.server.occurrences.OccurrencesResult
import org.junit.Test

import static org.junit.Assert.*

class OccurrenceTest extends AbstractWebServerTest {
	
	def protected getOccurrences(CharSequence resourceContent) {
		val content = resourceContent.toString
		val offset = content.indexOf('#')
		val occurrences = getService(#{
				'serviceType' -> 'occurrences',
				'fullText' -> content.replace('#', ''),
				'caretOffset' -> offset.toString
			})
		occurrences.service.apply() as OccurrencesResult
	}
	
	def protected assertOccurrences(CharSequence resourceContent, CharSequence expectation) {
		assertEquals(expectation.toString.trim, resourceContent.toString.normalizeLineSeparator.occurrences.toString.trim)
	}
	
	@Test 
	def void testNoOccurrenceOnEmptyFile() {
		val result = '#'.occurrences
		assertTrue(result.readRegions.empty)
		assertTrue(result.writeRegions.empty)
	}
	
	@Test 
	def void testNoOccurrencesOnKeyword() {
		val result = '''
			#state foo
		''' .occurrences
		assertTrue(result.readRegions.empty)
		assertTrue(result.writeRegions.empty)
	}
	
	@Test 
	def void testSingleWriteOccurrence() {
		'''
			state #foo
		''' .assertOccurrences('''
			OccurrencesResult [
			  stateId = "-80000000"
			  writeRegions = ArrayList (
			    [6:3]
			  )
			  readRegions = ArrayList ()
			]
		''')
	}

	@Test 
	def void testReadAndWriteOccurrence() {
		'''
			input signal #foo
			state bar 
				set foo == true
				set foo == true
			end
		''' .assertOccurrences('''
			OccurrencesResult [
			  stateId = "-80000000"
			  writeRegions = ArrayList (
			    [13:3]
			  )
			  readRegions = ArrayList (
			    [33:3],
			    [50:3]
			  )
			]
		''')
	}
	
	@Test 
	def void testReadAndWriteOccurrence_2() {
		'''
			input signal foo
			state bar 
				set #foo == true
				set foo == true
			end
		''' .assertOccurrences('''
			OccurrencesResult [
			  stateId = "-80000000"
			  writeRegions = ArrayList (
			    [13:3]
			  )
			  readRegions = ArrayList (
			    [33:3],
			    [50:3]
			  )
			]
		''')
	}

	@Test 
	def void testSyntaxError() {
		'''
			state foo
			end
			asdf#
			state bar 
			end
		''' .assertOccurrences('''
			OccurrencesResult [
			  stateId = "-80000000"
			  writeRegions = ArrayList ()
			  readRegions = ArrayList ()
			]
		''')
	}
	
}
