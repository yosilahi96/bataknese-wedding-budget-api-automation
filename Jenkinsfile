pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
        timeout(time: 20, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    parameters {
        choice(
            name: 'SUITE',
            choices: ['all', 'api', 'ui', 'login'],
            description: 'Cucumber suite to run'
        )
    }

    triggers {
        githubPush()
    }

    environment {
        BASE_API_URL = 'https://bataknese-wedding-budget.onrender.com'
        LOGIN_PATH = '/api/auth/login'
        LOGIN_SUCCESS_STATUS = '200'
        BROWSER = 'chrome'
        HEADLESS = 'true'
        DEFAULT_TIMEOUT = '10'
        RUBYLIB = "${WORKSPACE}/support/ruby_overrides"
    }

    stages {
        stage('Checkout repository') {
            steps {
                checkout scm
            }
        }

        stage('Set up Ruby') {
            steps {
                sh '''
                    set -e
                    ruby --version
                    bundle --version
                    bundle config set path vendor/bundle
                    if ! bundle check; then
                        bundle install --jobs 4 --retry 3
                    fi
                '''
            }
        }

        stage('Run Cucumber suite') {
            steps {
                sh '''
                    set -e
                    suite="${SUITE:-all}"
                    mkdir -p reports

                    case "$suite" in
                        api)
                            bundle exec cucumber -p api \
                                --format html --out reports/cucumber.html \
                                --format json --out reports/cucumber.json
                            ;;
                        ui)
                            bundle exec cucumber -p ui \
                                --format html --out reports/cucumber.html \
                                --format json --out reports/cucumber.json
                            ;;
                        login)
                            bundle exec cucumber --tags '@login' \
                                --format html --out reports/cucumber.html \
                                --format json --out reports/cucumber.json
                            ;;
                        *)
                            bundle exec cucumber \
                                --format html --out reports/cucumber.html \
                                --format json --out reports/cucumber.json
                            ;;
                    esac
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts(
                artifacts: 'reports/**',
                allowEmptyArchive: true
            )

            publishHTML([
                reportDir: 'reports',
                reportFiles: 'cucumber.html',
                reportName: 'Cucumber Test Report',
                keepAll: true,
                alwaysLinkToLastBuild: true,
                allowMissing: true
            ])
        }
    }
}
