#!groovy
import groovy.json.JsonSlurperClassic
node {

    def HUB_ORG='cmduquer@curious-badger-6o45dw.com'
    def SFDC_HOST ='https://login.salesforce.com'
    def JWT_KEY_CRED_ID ='395ce5cc-458e-4304-8235-e157e4fa6c1e'
    def CONNECTED_APP_CONSUMER_KEY='3MVG9l2zHsylwlpSP0BI46IF_2EJCzcrwmI0eBagNivGwKlsl0U2IaWJz1rMF4ISt0NfZ21D.G6h36rhR.mOn'
    def DEPLOYDIR='src'
    def TEST_LEVEL='RunLocalTests'


    println 'KEY IS' 
    println JWT_KEY_CRED_ID
    println HUB_ORG
    println SFDC_HOST
    println CONNECTED_APP_CONSUMER_KEY
    
    stage('checkout') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Auth') {
			rc = sh returnStatus: true, script: "/usr/local/bin/sfdx force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"  
            if (rc != 0) { error 'hub org authorization failed' }

			println rc
        }

        stage('jestTests') {
                rc = sh returnStatus: true, script: 'npm install'
                println rc
                rc = sh returnStatus: true, script: 'npm run test:unit'
                if (rc != 0) { 
                    error 'Deploy failed' 
                } else {
                    rc = sh returnStatus: true, script: 'npm run test:unit:coverage'
                    println rc
                }
            }
        
        stage('Deploy') {
                rc = sh returnStatus: true, script: "/usr/local/bin/sfdx force:source:convert -r force-app -d src -x src/package.xml"
                if (rc != 0) { 
                    error 'Deploy failed' 
                } else {
                    rc = sh returnStatus: true, script: "/usr/local/bin/sfdx force:mdapi:deploy -d src/ --targetusername ${HUB_ORG} -w -1 -l ${TEST_LEVEL}"
                    if (rc != 0) { 
                        error 'Deploy failed' 
                    }
                }
                println rc
            }
    }
}