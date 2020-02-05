/*******************************************************************************
 * Copyright (c) 2015 itemis AG (http://www.itemis.eu) and others.
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************/
package org.eclipse.xtext.web.server.hover

import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtend.lib.annotations.ToString
import org.eclipse.xtext.web.server.IServiceResult

/**
 * Result object returned by the hover service.
 */
@Data
@ToString(skipNulls = true)
class HoverResult implements IServiceResult {
	
	String stateId
	
	String title
	
	String content
	
	new(String stateId) {
		this.stateId = stateId
		this.title = null
		this.content = null
	}
	
	new(String stateId, String title, String content) {
		this.stateId = stateId
		this.title = title
		this.content = content
	}
	
}