provider "aws" {
  region = "${var.region}"
}


data "template_file" "service" {
  template =  <<EOF
      { "type": "metric", "x": 0, "y": 24, "width": 24, "height": 6, "properties": { "view": "timeSeries", "metrics": [ [ "AWS/ECS", "MemoryUtilization", "ServiceName", "${var.ServiceName1}", "ClusterName", "${var.ClusterName}", { "stat": "SampleCount", "period": 30 } ], [ "...", "${var.ServiceName1}", ".", ".", { "stat": "SampleCount", "period": 30 } ] ], "region": "${var.region}", "title": "ECS- Containers", "period": 300, "stacked": false, "yAxis": { "left": { "min": 0 } } } },
   { "type": "metric", "x": 0, "y": 18, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ECS", "MemoryUtilization", "ServiceName", "${var.ServiceName1}", "ClusterName", "${var.ClusterName}" ], [ "...", { "stat": "Minimum" } ], [ "...", { "stat": "Maximum" } ] ], "region": "${var.region}", "title": "MemoryUtilization", "period": 300 } },
   { "type": "metric", "x": 0, "y": 12, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ECS", "MemoryUtilization", "ServiceName", "${var.ServiceName1}", "ClusterName", "${var.ClusterName}", { "label": "MemoryUtilization average" } ], [ "...", { "stat": "Minimum" } ], [ "...", { "stat": "Maximum" } ] ], "region": "${var.region}", "period": 300, "title": "MemoryUtilization" } }
EOF
}

data "template_file" "loadbalancer" {
  template =  <<EOF
   { "type": "metric", "x": 0, "y": 48, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${var.LoadBalancer}", { "period": 60, "stat": "Sum" } ] ], "region": "${var.region}", "title": "ALB>AvgTargetResponseTime", "period": 300 } },
   { "type": "metric", "x": 0, "y": 54, "width": 24, "height": 3, "properties": { "view": "singleValue", "stacked": false, "metrics": [ [ "AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", "${var.LoadBalancer}", { "period": 86400, "stat": "Sum" } ], [ ".", "HTTPCode_Target_4XX_Count", ".", ".", { "period": 86400, "stat": "Sum" } ], [ ".", "HTTPCode_Target_5XX_Count", ".", ".", { "period": 86400, "stat": "Sum" } ] ], "region": "${var.region}", "period": 300, "title": "2xx_client request sucessful,4xx_client error,5xx_Server error" } },
   { "type": "metric", "x": 0, "y": 57, "width": 24, "height": 3, "properties": { "view": "singleValue", "metrics": [ [ "AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", "${var.TargetGroup}", "LoadBalancer", "${var.LoadBalancer}" ], [ ".", "UnHealthyHostCount", ".", ".", ".", "." ] ], "region": "${var.region}", "title": "ALB>HealthyHostCount, UnHealthyHostCount" } },
   { "type": "metric", "x": 0, "y": 36, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ApplicationELB", "RequestCount", "TargetGroup", "${var.TargetGroup}", "LoadBalancer", "${var.LoadBalancer}", { "stat": "Sum" } ] ], "region": "${var.region}", "period": 300, "title": "ALB-RequestCount" } },
   { "type": "metric", "x": 0, "y": 42, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ApplicationELB", "RequestCountPerTarget", "TargetGroup", "${var.TargetGroup}", "LoadBalancer", "${var.LoadBalancer}", { "stat": "Sum" } ] ], "region": "${var.region}", "period": 300, "title": "ALB-RequestCountPerTarget" } }
EOF
}

data "template_file" "db1" {
  template =  <<EOF
   { "type": "metric", "x": 0, "y": 60, "width": 12, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}" ], [ ".", "WriteIOPS", ".", "." ] ], "region": "${var.region}", "title": "RDS>primary node-ReadIOPS, WriteIOPS " } },
   { "type": "metric", "x": 12, "y": 72, "width": 12, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}" ], [ ".", "WriteLatency", ".", "." ] ], "region": "${var.region}", "title": "RDS>Primary-ReadLatency, WriteLatency" } },
   { "type": "metric", "x": 0, "y": 84, "width": 24, "height": 3, "properties": { "view": "singleValue", "metrics": [ [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}" ], [ ".", "SwapUsage", ".", "." ], [ ".", "CPUUtilization", ".", "." ], [ ".", "DiskQueueDepth", ".", "." ], [ ".", "FreeableMemory", ".", "." ], [ ".", "FreeStorageSpace", ".", "." ] ], "region": "${var.region}", "title": "RDS >Metrics Primary" } },
   { "type": "metric", "x": 0, "y": 87, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}" ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 6, "y": 87, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "SwapUsage", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}", { "color": "#ff7f0e" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 87, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}", { "color": "#2ca02c" } ] ], "region": "${var.region}", "period": 300 } },
   { "type": "metric", "x": 18, "y": 87, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "DiskQueueDepth", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}", { "color": "#d62728" } ] ], "region": "${var.region}", "period": 300 } },
   { "type": "metric", "x": 0, "y": 90, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}", { "color": "#9467bd" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 90, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}", { "color": "#8c564b" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 60, "width": 12, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "region": "${var.region}", "metrics": [ [ "AWS/RDS", "WriteThroughput", "DBInstanceIdentifier", "${var.DBInstanceIdentifier1}" ], [ ".", "ReadThroughput", ".", "." ] ], "title": "RDS-Primary ReadThroughput, WriteThroughput" } }
EOF
}

data "template_file" "db2" {
  template =  <<EOF
   { "type": "metric", "x": 0, "y": 96, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}" ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 0, "y": 66, "width": 12, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}" ], [ ".", "WriteIOPS", ".", "." ], [ ".", "ReadIOPS", ".", "${var.DBInstanceIdentifier2}" ], [ ".", "WriteIOPS", ".", "." ] ], "region": "${var.region}", "period": 300, "title": "RDS>Replica node-ReadIOPS, WriteIOPS" } },
   { "type": "metric", "x": 0, "y": 78, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}" ], [ ".", "WriteLatency", ".", "." ], [ ".", "ReadLatency", ".", "${var.DBInstanceIdentifier2}" ], [ ".", "WriteLatency", ".", "." ] ], "region": "${var.region}", "title": "RDS>Replica-ReadLatency, WriteLatency" } },
   { "type": "metric", "x": 0, "y": 93, "width": 24, "height": 3, "properties": { "view": "singleValue", "metrics": [ [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}" ], [ ".", "SwapUsage", ".", "." ], [ ".", "CPUUtilization", ".", "." ], [ ".", "DiskQueueDepth", ".", "." ], [ ".", "FreeableMemory", ".", "." ], [ ".", "FreeStorageSpace", ".", "." ] ], "region": "${var.region}", "title": "RDS>Replica1 metrics", "period": 300 } },
   { "type": "metric", "x": 6, "y": 96, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "SwapUsage", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}", { "color": "#ff7f0e" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 96, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}", { "color": "#2ca02c" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 18, "y": 96, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "DiskQueueDepth", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}", { "color": "#d62728" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 99, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}", { "color": "#9467bd" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 0, "y": 99, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}", { "color": "#8c564b" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 66, "width": 12, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "ReadThroughput", "DBInstanceIdentifier", "${var.DBInstanceIdentifier2}" ], [ ".", "WriteThroughput", ".", "." ] ], "region": "${var.region}", "title": "RDS-Replica1-ReadThroughput, WriteThroughput" } }
EOF
}

data "template_file" "db3" {
  template =  <<EOF
  { "type": "metric", "x": 0, "y": 102, "width": 24, "height": 3, "properties": { "view": "singleValue", "metrics": [ [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.DBInstanceIdentifier3}" ], [ ".", "SwapUsage", ".", "." ], [ ".", "CPUUtilization", ".", "." ], [ ".", "DiskQueueDepth", ".", "." ], [ ".", "FreeableMemory", ".", "." ], [ ".", "FreeStorageSpace", ".", "." ] ], "region": "${var.region}", "title": "RDS>Replica 2 Metrics", "period": 300 } },
   { "type": "metric", "x": 0, "y": 105, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${var.DBInstanceIdentifier3}" ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 105, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${var.DBInstanceIdentifier3}", { "color": "#2ca02c" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 6, "y": 105, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "SwapUsage", "DBInstanceIdentifier", "${var.DBInstanceIdentifier3}", { "color": "#ff7f0e" } ] ], "region": "${var.region}", "period": 300 } },
   { "type": "metric", "x": 18, "y": 105, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "DiskQueueDepth", "DBInstanceIdentifier", "${var.DBInstanceIdentifier3}", { "color": "#d62728" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 0, "y": 108, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${var.DBInstanceIdentifier3}", { "color": "#9467bd" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 108, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${var.DBInstanceIdentifier3}", { "color": "#8c564b" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 0, "y": 72, "width": 12, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "region": "${var.region}", "metrics": [ [ "AWS/RDS", "ReadThroughput", "DBInstanceIdentifier", "${var.DBInstanceIdentifier3}" ], [ ".", "WriteThroughput", ".", "." ] ], "title": "RDS-Replica2-ReadThroughput, WriteThroughput" } }

EOF
}

data "template_file" "asg" {
  template =  <<EOF
  { "type": "metric", "x": 0, "y": 30, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", "${var.AutoScalingGroupName}" ] ], "region": "${var.region}", "title": "EC2- Instances ", "period": 300, "yAxis": { "left": { "min": 0 } } } }
EOF
}

data "template_file" "cache1" {
  template =  <<EOF
  { "type": "metric", "x": 0, "y": 117, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "NewConnections", "CacheClusterId", "${var.CacheCluster1Id}" ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 6, "y": 117, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "SwapUsage", "CacheClusterId", "${var.CacheCluster1Id}", { "color": "#ff7f0e" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 117, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "${var.CacheCluster1Id}", { "color": "#2ca02c" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 18, "y": 117, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "CurrItems", "CacheClusterId", "${var.CacheCluster1Id}", { "color": "#d62728" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 0, "y": 120, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "Evictions", "CacheClusterId", "${var.CacheCluster1Id}", { "color": "#9467bd" } ] ], "region": "${var.region}", "period": 300 } },
   { "type": "metric", "x": 12, "y": 120, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "FreeableMemory", "CacheClusterId", "${var.CacheCluster1Id}", { "color": "#8c564b" } ] ], "region": "${var.region}", "period": 300 } },
   { "type": "metric", "x": 0, "y": 111, "width": 24, "height": 6, "properties": { "view": "singleValue", "metrics": [ [ "AWS/ElastiCache", "NewConnections", "CacheClusterId", "${var.CacheCluster1Id}" ], [ ".", "SwapUsage", ".", "." ], [ ".", "CPUUtilization", ".", "." ], [ ".", "CurrItems", ".", "." ], [ ".", "Evictions", ".", "." ], [ ".", "FreeableMemory", ".", "." ] ], "region": "${var.region}", "title": "Elasticache -primary", "period": 300 } }

EOF
}

data "template_file" "cache2" {
  template =  <<EOF
  { "type": "metric", "x": 0, "y": 129, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "NewConnections", "CacheClusterId", "${var.CacheCluster2Id}" ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 6, "y": 129, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "SwapUsage", "CacheClusterId", "${var.CacheCluster2Id}", { "color": "#ff7f0e" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 129, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "${var.CacheCluster2Id}", { "color": "#2ca02c" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 0, "y": 132, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "Evictions", "CacheClusterId", "${var.CacheCluster2Id}", { "color": "#9467bd" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 12, "y": 132, "width": 12, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "FreeableMemory", "CacheClusterId", "${var.CacheCluster2Id}", { "color": "#8c564b" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 18, "y": 129, "width": 6, "height": 3, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ElastiCache", "CurrConnections", "CacheClusterId", "${var.CacheCluster2Id}", { "color": "#d62728" } ] ], "region": "${var.region}" } },
   { "type": "metric", "x": 0, "y": 123, "width": 24, "height": 6, "properties": { "view": "singleValue", "metrics": [ [ "AWS/ElastiCache", "NewConnections", "CacheClusterId", "${var.CacheCluster2Id}" ], [ ".", "SwapUsage", ".", "." ], [ ".", "CPUUtilization", ".", "." ], [ ".", "CurrItems", ".", "." ], [ ".", "Evictions", ".", "." ], [ ".", "FreeableMemory", ".", "." ] ], "region": "${var.region}", "title": "Elasticache-Replica", "period": 300 } }

EOF
}


data "template_file" "cluster" {
  template =  <<EOF
  { "type": "metric", "x": 0, "y": 0, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ECS", "CPUReservation", "ClusterName", "${var.ClusterName}", { "period": 60 } ], [ ".", "CPUUtilization", ".", ".", { "period": 60 } ] ], "region": "${var.region}", "period": 300, "title": "ECS-CPUReservation, CPUUtilization" } },
   { "type": "metric", "x": 0, "y": 6, "width": 24, "height": 6, "properties": { "view": "timeSeries", "stacked": false, "metrics": [ [ "AWS/ECS", "MemoryReservation", "ClusterName", "${var.ClusterName}", { "period": 60 } ], [ ".", "MemoryUtilization", ".", ".", { "period": 60 } ] ], "region": "${var.region}", "period": 300, "title": "ECS-MemoryReservation, MemoryUtilization", "annotations": { "horizontal": [ { "label": "70% ScaleUp", "value": 70 }, { "color": "#2ca02c", "label": "55% ScaleDown", "value": 55 } ] } } }

EOF
}

resource "local_file" "service" {
    content     = "${data.template_file.service.template}"
    filename = "${path.module}/service.template"
    count = "${var.ServiceName1 != "null" ? 1 : 0}"
}
resource "local_file" "loadbalancer" {
    content     = "${data.template_file.loadbalancer.template}"
    filename = "${path.module}/loadbalancer.template"
    count = "${var.LoadBalancer != "null" ? 1 : 0}"
}
resource "local_file" "db1" {
    content     = "${data.template_file.db1.template}"
    filename = "${path.module}/db1.template"
    count = "${var.DBInstanceIdentifier1 != "null" ? 1 : 0}"
}
resource "local_file" "db2" {
    content     = "${data.template_file.db2.template}"
    filename = "${path.module}/db2.template"
    count = "${var.DBInstanceIdentifier2 != "null" ? 1 : 0}"
}
resource "local_file" "db3" {
    content     = "${data.template_file.db3.template}"
    filename = "${path.module}/db3.template"
    count = "${var.DBInstanceIdentifier3 != "null" ? 1 : 0}"
}
resource "local_file" "asg" {
    content     = "${data.template_file.asg.template}"
    filename = "${path.module}/asg.template"
    count = "${var.AutoScalingGroupName != "null" ? 1 : 0}"
}
resource "local_file" "cache1" {
    content     = "${data.template_file.cache1.template}"
    filename = "${path.module}/cache1.template"
    count = "${var.CacheCluster1Id != "null" ? 1 : 0}"
}
resource "local_file" "cache2" {
    content     = "${data.template_file.cache2.template}"
    filename = "${path.module}/cache2.template"
    count = "${var.CacheCluster2Id != "null" ? 1 : 0}"
}
resource "local_file" "cluster" {
    content     = "${data.template_file.cluster.template}"
    filename = "${path.module}/cluster.template"
    count = "${var.ClusterName != "null" ? 1 : 0}"
}

resource "null_resource" "shell_script" {
  provisioner "local-exec" {
    command = "${path.module}/shell.sh ${path.module}"
    interpreter = ["/bin/bash", "-c"]
  }
}

data "template_file" "cd_dashboard" {
  template = "${file("${path.module}/final.json")}"
  depends_on = ["null_resource.shell_script"]
}


#resource "aws_cloudwatch_dashboard" "main" {
#   dashboard_name = "${var.dashboard_name}"
#   dashboard_body = "${data.template_file.cd_dashboard.template}"
#}

resource "aws_cloudwatch_dashboard" "main" {
   dashboard_name = "${var.dashboard_name}"
   dashboard_body = "${file("${path.module}/final.json")}"
   depends_on = ["null_resource.shell_script"]
}