output "memcached_endpoint" {
  value = aws_elasticache_cluster.cache_cluster.cache_nodes[0].address
}

