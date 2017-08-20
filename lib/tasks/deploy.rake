task :deploy => :environment do
    client = Aws::OpsWorks::Client.new(region: 'us-east-1')
    deployment_id = client.create_deployment({
        stack_id: ENV['STACK_ID'],
        app_id: ENV['APP_ID'],
        command: { 
            name: "deploy",

            args: {
                "migrate" => ["true"],
            },
        },
        comment: "Continuous Integration Deploy",
    }).deployment_id
   puts deployment_id
    status = client.describe_deployments({
        deployment_ids: [deployment_id],
    }).deployments[0].status

    while status == 'running'
        sleep 5
        status = client.describe_deployments({
            deployment_ids: [deployment_id],
        }).deployments[0].status
    end
    raise if status == 'failed'
end
