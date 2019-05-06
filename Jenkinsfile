node {
	properties([
		[$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', numToKeepStr: '15']]
		, pipelineTriggers([upstream(threshold: 'SUCCESS', upstreamProjects: 'xtext-extras/milestone_2.18.0.M2')])
	])
	
	stage('Checkout') {
		checkout scm
	}
	
	stage('Build') {
		sh "./gradlew clean generateExampleLanguages build createLocalMavenRepo -PuseJenkinsSnapshots=true -PJENKINS_URL=$JENKINS_URL -PignoreTestFailures=true --refresh-dependencies --continue"
		step([$class: 'JUnitResultArchiver', testResults: '**/build/test-results/test/*.xml'])
	}
	
	archive 'build/maven-repository/**'
}
