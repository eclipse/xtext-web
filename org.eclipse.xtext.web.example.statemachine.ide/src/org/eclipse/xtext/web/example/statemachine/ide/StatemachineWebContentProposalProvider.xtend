/*******************************************************************************
 * Copyright (c) 2015, 2016 itemis AG (http://www.itemis.eu) and others.
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************/
package org.eclipse.xtext.web.example.statemachine.ide

import com.google.inject.Inject
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalProvider
import org.eclipse.xtext.web.example.statemachine.services.StatemachineGrammarAccess

import static org.eclipse.xtext.web.example.statemachine.statemachine.StatemachinePackage.Literals.*

class StatemachineWebContentProposalProvider extends IdeContentProposalProvider {
	
	@Inject extension StatemachineGrammarAccess
	
	@Inject StatemachineTemplateProposalProvider templateProvider
	
	override dispatch createProposals(RuleCall ruleCall, ContentAssistContext context,
			IIdeContentProposalAcceptor acceptor) {
		switch ruleCall.rule {
			
			case BOOLEANRule: {
				if ('true'.startsWith(context.prefix)) {
					val trueEntry = proposalCreator.createProposal('true', context)
					acceptor.accept(trueEntry, proposalPriorities.getDefaultPriority(trueEntry))
				}
				if ('false'.startsWith(context.prefix)) {
					val falseEntry = proposalCreator.createProposal('false', context)
					acceptor.accept(falseEntry, proposalPriorities.getDefaultPriority(falseEntry))
				}
			}
			case stateRule: {
				templateProvider.createStateProposal(context, acceptor)
			}
			
			default:
				super._createProposals(ruleCall, context, acceptor)	
		}
	}
	
	override dispatch createProposals(Assignment assignment, ContentAssistContext context,
			IIdeContentProposalAcceptor acceptor) {
		switch assignment {
			case eventAccess.signalAssignment_0: {
				val scope = scopeProvider.getScope(context.currentModel, EVENT__SIGNAL)
				for (description : scope.allElements.filter[getEClass == INPUT_SIGNAL]) {
					val entry = proposalCreator.createProposal(description.name.toString, context) [
						source = description
						description = 'input signal'
					]
					acceptor.accept(entry, proposalPriorities.getCrossRefPriority(description, entry))
				}
			}
			
			case commandAccess.signalAssignment_1: {
				val scope = scopeProvider.getScope(context.currentModel, COMMAND__SIGNAL)
				for (description : scope.allElements.filter[getEClass == OUTPUT_SIGNAL]) {
					val entry = proposalCreator.createProposal(description.name.toString, context) [
						source = description
						description = 'output signal'
					]
					acceptor.accept(entry, proposalPriorities.getCrossRefPriority(description, entry))
				}
			}
			
			case eventAccess.valueAssignment_2,
			case commandAccess.newValueAssignment_3: {
				// Proposals are created by RuleCall dispatch method
			}
			
			default:
				super._createProposals(assignment, context, acceptor)
		}
	}
	
	override protected filterKeyword(Keyword keyword, ContentAssistContext context) {
		switch keyword {
			case stateAccess.stateKeyword_0:
				false
			default:
				super.filterKeyword(keyword, context)
		}
	}
	
}
