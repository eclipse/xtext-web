/*******************************************************************************
 * Copyright (c) 2015 itemis AG (http://www.itemis.eu) and others.
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************/

({
	baseUrl: ".",
	name: "xtext/xtext-ace",
	paths: {
		"jquery": "empty:",
		"ace/ace": "empty:",
		"ace/range": "empty:",
		"ace/ext/language_tools": "empty:"
	},
	exclude: [ "jquery", "ace/range", "ace/ext/language_tools" ]
})