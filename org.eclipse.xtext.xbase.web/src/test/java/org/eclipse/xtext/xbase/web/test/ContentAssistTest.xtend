/*******************************************************************************
 * Copyright (c) 2015, 2017 itemis AG (http://www.itemis.eu) and others.
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************/
package org.eclipse.xtext.xbase.web.test

import org.eclipse.xtext.web.server.contentassist.ContentAssistResult
import org.junit.Test

class ContentAssistTest extends AbstractXbaseWebTest {
	
	protected def assertContentAssistResult(CharSequence resourceContent, CharSequence expectedResult) {
		var contentString = resourceContent.toString.normalizeLineSeparator
		val cursorOffset = contentString.indexOf('|')
		if (cursorOffset >= 0) {
			contentString = contentString.substring(0, cursorOffset) + contentString.substring(cursorOffset + 1)
			assertContentAssistResult(contentString, cursorOffset, expectedResult)
		} else
			assertContentAssistResult(resourceContent, 0, expectedResult)
	}
	
	protected def assertContentAssistResult(CharSequence resourceContent, int offset, CharSequence expectedResult) {
		val contentAssist = getService(#{
				'serviceType' -> 'assist', 
				'fullText' -> resourceContent.toString,
				'caretOffset' -> offset.toString
			})
		val result = contentAssist.service.apply() as ContentAssistResult
		assertEquals(expectedResult.toString, result.toString)
	}
	
	@Test def testExtendsType() {
		'entity Foo extends AbstractQu|'.assertContentAssistResult('''
			ContentAssistResult [
			  stateId = "-80000000"
			  entries = ArrayList (
			    ContentAssistEntry [
			      prefix = "AbstractQu"
			      proposal = "AbstractQueue"
			      description = "java.util.AbstractQueue"
			      textReplacements = ArrayList (
			        replace region [0 / length: 0] '
			        import java.util.AbstractQueue'
			      )
			      editPositions = ArrayList ()
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "AbstractQu"
			      proposal = "AbstractQueuedLongSynchronizer"
			      description = "java.util.concurrent.locks.AbstractQueuedLongSynchronizer"
			      textReplacements = ArrayList (
			        replace region [0 / length: 0] '
			        import java.util.concurrent.locks.AbstractQueuedLongSynchronizer'
			      )
			      editPositions = ArrayList ()
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "AbstractQu"
			      proposal = "AbstractQueuedSynchronizer"
			      description = "java.util.concurrent.locks.AbstractQueuedSynchronizer"
			      textReplacements = ArrayList (
			        replace region [0 / length: 0] '
			        import java.util.concurrent.locks.AbstractQueuedSynchronizer'
			      )
			      editPositions = ArrayList ()
			      kind = "REFERENCE"
			    ]
			  )
			]''')
	}
	
	@Test def testPropertyType() {
		'entity Foo { bar: AbstractQu| }'.assertContentAssistResult('''
			ContentAssistResult [
			  stateId = "-80000000"
			  entries = ArrayList (
			    ContentAssistEntry [
			      prefix = "AbstractQu"
			      proposal = "AbstractQueue"
			      description = "java.util.AbstractQueue"
			      textReplacements = ArrayList (
			        replace region [0 / length: 0] '
			        import java.util.AbstractQueue'
			      )
			      editPositions = ArrayList ()
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "AbstractQu"
			      proposal = "AbstractQueuedLongSynchronizer"
			      description = "java.util.concurrent.locks.AbstractQueuedLongSynchronizer"
			      textReplacements = ArrayList (
			        replace region [0 / length: 0] '
			        import java.util.concurrent.locks.AbstractQueuedLongSynchronizer'
			      )
			      editPositions = ArrayList ()
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "AbstractQu"
			      proposal = "AbstractQueuedSynchronizer"
			      description = "java.util.concurrent.locks.AbstractQueuedSynchronizer"
			      textReplacements = ArrayList (
			        replace region [0 / length: 0] '
			        import java.util.concurrent.locks.AbstractQueuedSynchronizer'
			      )
			      editPositions = ArrayList ()
			      kind = "REFERENCE"
			    ]
			  )
			]''')
	}
	
	@Test def testListMethods() {
		'entity Foo { op bar(): void { #[\'blub\'].add| } }'.assertContentAssistResult('''
			ContentAssistResult [
			  stateId = "-80000000"
			  entries = ArrayList (
			    ContentAssistEntry [
			      prefix = "add"
			      proposal = "add()"
			      label = "add(E arg0) : boolean"
			      description = "List"
			      escapePosition = 45
			      textReplacements = ArrayList ()
			      editPositions = ArrayList (
			        [44:0]
			      )
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "add"
			      proposal = "add()"
			      label = "add(int arg0, E arg1) : void"
			      description = "List"
			      escapePosition = 45
			      textReplacements = ArrayList ()
			      editPositions = ArrayList (
			        [44:0]
			      )
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "add"
			      proposal = "addAll()"
			      label = "addAll(Collection<? extends E> arg0) : boolean"
			      description = "List"
			      escapePosition = 48
			      textReplacements = ArrayList ()
			      editPositions = ArrayList (
			        [47:0]
			      )
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "add"
			      proposal = "addAll()"
			      label = "addAll(Iterable<? extends T> arg1) : boolean"
			      description = "CollectionExtensions"
			      escapePosition = 48
			      textReplacements = ArrayList ()
			      editPositions = ArrayList (
			        [47:0]
			      )
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "add"
			      proposal = "addAll()"
			      label = "addAll(T... arg1) : boolean"
			      description = "CollectionExtensions"
			      escapePosition = 48
			      textReplacements = ArrayList ()
			      editPositions = ArrayList (
			        [47:0]
			      )
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "add"
			      proposal = "addAll()"
			      label = "addAll(int arg0, Collection<? extends E> arg1) : boolean"
			      description = "List"
			      escapePosition = 48
			      textReplacements = ArrayList ()
			      editPositions = ArrayList (
			        [47:0]
			      )
			      kind = "REFERENCE"
			    ],
			    �operators�
			  )
			]''')
	}
	
	@Test def testMembers() {
		'''
			entity Foo {
				foobar1: String
				op foobar2(): String {}
				op baz(): void {
					println(foob|)
				}
			}
		'''.assertContentAssistResult('''
			ContentAssistResult [
			  stateId = "-80000000"
			  entries = ArrayList (
			    ContentAssistEntry [
			      prefix = "foob"
			      proposal = "foobar1"
			      label = "foobar1 : String"
			      description = "Foo"
			      escapePosition = 90
			      textReplacements = ArrayList ()
			      editPositions = ArrayList ()
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "foob"
			      proposal = "foobar1 = value"
			      label = "foobar1 = value : void"
			      description = "Foo.setFoobar1()"
			      escapePosition = 98
			      textReplacements = ArrayList ()
			      editPositions = ArrayList (
			        [93:5]
			      )
			      kind = "REFERENCE"
			    ],
			    ContentAssistEntry [
			      prefix = "foob"
			      proposal = "foobar2"
			      label = "foobar2 : String"
			      description = "Foo.foobar2()"
			      escapePosition = 90
			      textReplacements = ArrayList ()
			      editPositions = ArrayList ()
			      kind = "REFERENCE"
			    ]
			  )
			]''')
	}
	
	def private operators() '''
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "!="
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "!=="
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "&&"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "+"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "->"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "<"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "<="
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "<=>"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "=="
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "==="
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "=>"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = ">"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = ">="
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "?:"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = "||"
	      description = "JvmOperation"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList ()
	      kind = "REFERENCE"
	    ],
	    ContentAssistEntry [
	      prefix = ""
	      proposal = ""value""
	      description = "STRING"
	      textReplacements = ArrayList ()
	      editPositions = ArrayList (
	        [44:5]
	      )
	      kind = "TEXT"
	    ]
	'''
	
}
