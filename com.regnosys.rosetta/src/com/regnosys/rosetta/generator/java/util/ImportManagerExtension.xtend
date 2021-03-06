package com.regnosys.rosetta.generator.java.util

import org.eclipse.xtend2.lib.StringConcatenationClient

class ImportManagerExtension {

	def importMethod(Class<?> clazz, String methodName) {
		clazz.methods.findFirst[name == methodName]
	}

	def importWildCard(Class<?> clazz) {
		JavaType.create(clazz.name + '.*')
	}

	def ImportingStringConcatination tracImports(StringConcatenationClient scc, String... reservedSimpleNames) {
		val isc = new ImportingStringConcatination()
		reservedSimpleNames.forEach[isc.addReservedSimpleName(it)]
		isc.append(scc)
		isc
	}
}
