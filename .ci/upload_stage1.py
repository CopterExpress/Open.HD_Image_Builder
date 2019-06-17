#!/usr/bin/env python3

from github import Github
import os

API_KEY = os.environ['GITHUB_OAUTH_TOKEN']

if __name__ == '__main__':
    repo = os.sys.argv[1]
    tag = os.sys.argv[2]
    file = os.sys.argv[3]
    gh = Github(API_KEY)
    repo = gh.get_user("CopterExpress").get_repo(repo)
    release = repo.create_git_release(tag=tag, name=tag, message='Build {}'.format(tag))
    print('Uploading build artifacts')
    release.upload_asset(path=file, content_type='application/octet-stream')
    print('Done uploading build artifacts')
