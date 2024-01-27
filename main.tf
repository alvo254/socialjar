module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source = "./modules/eks"
  vpc = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet1
  subnet_id2 = module.vpc.public_subnet_az1
}

# module "sg" {
#   source = "./modules/sg"
# }