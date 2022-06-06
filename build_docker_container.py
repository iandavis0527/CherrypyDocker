import os
import datetime
import argparse


CONTAINER_NAME = "cherrypy"


def build_docker_container(version_number):
    os.system("docker image prune --all --force --filter until=700h")
    os.system("docker build --network=host -t {1}:{0} .".format(version_number, CONTAINER_NAME.replace("_", "-")))
    os.system("docker tag {0}:{1} {0}:latest".format(CONTAINER_NAME.replace("_", "-"), version_number))


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Script to facilitate building the docker container for Online Experiments")
    parser.add_argument(
        "--version_number", help="The version number to attach to the docker image tag name", default=None
    )

    args = parser.parse_args()

    if not args.version_number:
        args.version_number = datetime.datetime.now().strftime("%Y-%m-%d-%H-%M")

    build_docker_container(args.version_number)
