## https://unix.stackexchange.com/questions/298706/how-to-pass-parameters-to-function-in-a-bash-script
#!/bin/bash
export PGPASSWORD='wXfrQBjK4XYFY3KH6D2D'
export PGHOST='db-production.cglu874fh5rb.ap-east-1.rds.amazonaws.com'
export PGPORT='5432'
export PGUSER='postgres'

Execute() {
        result=$(psql -d $1 -c "select count(1) from log.admin_logs where recorded_on >= CURRENT_TIMESTAMP - interval '20 minutes'")
        result2=${result//-/}
        result3=${result2/count /}
        result4=${result3/\(1 row\)/}
        echo $result
        echo $result4

        if [ $result4 = "0" ]; then
                        for p in $(kubectl -n $2 get pods | grep backoffice-api | awk '{print $1}'); do kubectl delete pod $p -n $2 --grace-period=0 --force;done
                        echo "Staging Executed"
        fi
}

Execute "tgsstaging" "staging"
Execute "tgs" "prod"