package com.regnosys.rosetta.generator.java.util

import com.google.common.base.Strings
import com.regnosys.rosetta.rosetta.RosettaEvent
import com.regnosys.rosetta.rosetta.RosettaFeature
import com.regnosys.rosetta.rosetta.RosettaProduct
import com.regnosys.rosetta.rosetta.RosettaQualifiable
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.nodemodel.ICompositeNode
import org.eclipse.xtext.nodemodel.ILeafNode
import org.eclipse.xtext.nodemodel.util.NodeModelUtils

class RosettaGrammarUtil {
	
	def static String quote(String text) {
		return '"' + text.trim
				.replace('"', '\\\"')
				.replace('\r\n', '\n')
				.replace('\n\n', '\n')
				.replace('\n', '\\n" + \n\t"')
				 + '"'
	}
	
	def static String grammarText(EObject expr) {
		val node = NodeModelUtils.getNode(expr);
		if (node === null)
			return ''
		else if (node instanceof ILeafNode)
			return node.text
		else
			return node.leafNodes.map[Strings.nullToEmpty(text)].join
	}
	
	def static String grammarQualifiable(RosettaQualifiable q) {
		
		val andDataRules = q.andDataRules.map[it.name]
		val orDataRules = q.orDataRules.map[it.name]
		
		val grammar = new StringBuilder(toQualifiableName(q)).append(' ').append(q.name).append(' <').append(q.definition).append('>\n').append(grammarText(q.expression));
		if(!andDataRules.empty || !orDataRules.empty) {
			grammar.append('\nand ')
			if(!andDataRules.empty) {
				grammar.append(andDataRules.join(', '))
			} 
			if(!orDataRules.empty) {
				grammar.append(' or ').append(orDataRules.join(', '))
			}
			grammar.append(' apply')
		}
		return grammar.toString
	}
	
	private static def toQualifiableName(RosettaQualifiable qualifiableClass) {
		if(qualifiableClass instanceof RosettaEvent) {
			return 'isEvent'
		}
		else if (qualifiableClass instanceof RosettaProduct) {
			return 'isProduct'
		}
		else {
			throw new IllegalArgumentException("Unsupported class type " + qualifiableClass.class);
		}
	}
		
	def static String grammarWhenThen(EObject when, EObject then) {
		return "when " + grammarText(when).trim + "\nthen " + grammarText(then).trim
	}
	
	def static  String extractNodeText(EObject rosettaFeature, EStructuralFeature feature) {
		NodeModelUtils.findNodesForFeature(rosettaFeature, feature).map[NodeModelUtils.getTokenText(it)].join
	}
	
	def static String extractGrammarText(RosettaFeature rosettaFeature) {	
		val ICompositeNode node = NodeModelUtils.getNode(rosettaFeature);
		if (node === null) {
			return null;
		}
		if (node instanceof ILeafNode) {
			return node.getText();
		} else {
			val StringBuilder builder = new StringBuilder(Math.max(node.getTotalLength(), 1));

			for (ILeafNode leaf : node.getLeafNodes()) {
				builder.append(leaf.getText());
			}
			return builder.toString().trim.replace('\n', '\\n').replace("\r","");
		}
	}
}