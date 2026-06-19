pipeline {
    agent { label 'windows' }

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
        RUBYLIB = "${WORKSPACE}\\support\\ruby_overrides"
    }

    stages {
        stage('Checkout repository') {
            steps {
                checkout scm
            }
        }

        stage('Set up Ruby') {
            steps {
                powershell '''
                    $ErrorActionPreference = "Stop"
                    ruby --version
                    bundle --version
                    bundle config set path vendor/bundle
                    bundle check
                    if ($LASTEXITCODE -ne 0) {
                        bundle install --jobs 4 --retry 3
                        if ($LASTEXITCODE -ne 0) {
                            exit $LASTEXITCODE
                        }
                    }
                '''
            }
        }

        stage('Run Cucumber suite') {
            steps {
                powershell '''
                    $ErrorActionPreference = "Stop"
                    $suite = $env:SUITE
                    if ([string]::IsNullOrWhiteSpace($suite)) {
                        $suite = "all"
                    }

                    New-Item -ItemType Directory -Force reports | Out-Null
                    $reportArgs = @(
                        "--format", "html", "--out", "reports/cucumber.html",
                        "--format", "json", "--out", "reports/cucumber.json"
                    )

                    switch ($suite) {
                        "api"   { bundle exec cucumber -p api @reportArgs }
                        "ui"    { bundle exec cucumber -p ui @reportArgs }
                        "login" { bundle exec cucumber --tags "@login" @reportArgs }
                        default { bundle exec cucumber @reportArgs }
                    }

                    if ($LASTEXITCODE -ne 0) {
                        exit $LASTEXITCODE
                    }
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
