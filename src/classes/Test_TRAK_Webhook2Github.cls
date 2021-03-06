//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class Test_TRAK_Webhook2Github {
    
    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
        '  \"ref\": \"refs/heads/develop\",'+
        '  \"before\": \"5aa12e2985963ae94813502b24f16f6430eb8687\",'+
        '  \"after\": \"73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '  \"created\": false,'+
        '  \"deleted\": false,'+
        '  \"forced\": false,'+
        '  \"base_ref\": null,'+
        '  \"compare\": \"https://github.com/anilshivaraj/personal/compare/5aa12e298596...73d8a3227540\",'+
        '  \"commits\": ['+
        '    {'+
        '      \"id\": \"73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '      \"tree_id\": \"6406425e6d8800d283a444cbaa654853a3cb6e33\",'+
        '      \"distinct\": true,'+
        '      \"message\": \"123456\\n\\nyyyyyyyyyyyyyyyyy\",'+
        '      \"timestamp\": \"2016-09-01T18:11:31-04:00\",'+
        '      \"url\": \"https://github.com/anilshivaraj/personal/commit/73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '      \"author\": {'+
        '        \"name\": \"Anil Shivaraj\",'+
        '        \"email\": \"anil.shivaraj@gmail.com\",'+
        '        \"username\": \"anilshivaraj\"'+
        '      },'+
        '      \"committer\": {'+
        '        \"name\": \"GitHub\",'+
        '        \"email\": \"noreply@github.com\",'+
        '        \"username\": \"web-flow\"'+
        '      },'+
        '      \"added\": [],'+
        '      \"removed\": [],'+
        '      \"modified\": ['+
        '        \"README.md\"'+
        '      ]'+
        '    }'+
        '  ],'+
        '  \"head_commit\": {'+
        '    \"id\": \"73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '    \"tree_id\": \"6406425e6d8800d283a444cbaa654853a3cb6e33\",'+
        '    \"distinct\": true,'+
        '    \"message\": \"123456\\n\\nyyyyyyyyyyy  yyyyyy\",'+
        '    \"timestamp\": \"2016-09-01T18:11:31-04:00\",'+
        '    \"url\": \"https://github.com/anilshivaraj/personal/commit/73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '    \"author\": {'+
        '      \"name\": \"Anil Shivaraj\",'+
        '      \"email\": \"anil.shivaraj@gmail.com\",'+
        '      \"username\": \"anilshivaraj\"'+
        '    },'+
        '    \"committer\": {'+
        '      \"name\": \"GitHub\",'+
        '      \"email\": \"noreply@github.com\",'+
        '      \"username\": \"web-flow\"'+
        '    },'+
        '    \"added\": [],'+
        '    \"removed\": [],'+
        '    \"modified\": ['+
        '      \"README.md\"'+
        '    ]'+
        '  },'+
        '  \"repository\": {'+
        '    \"id\": 58100327,'+
        '    \"name\": \"personal\",'+
        '    \"full_name\": \"anilshivaraj/personal\",'+
        '    \"owner\": {'+
        '      \"name\": \"anilshivaraj\",'+
        '      \"email\": \"anil.shivaraj@gmail.com\"'+
        '    },'+
        '    \"private\": false,'+
        '    \"html_url\": \"https://github.com/anilshivaraj/personal\",'+
        '    \"description\": \"Test commit\",'+
        '    \"fork\": false,'+
        '    \"url\": \"https://github.com/anilshivaraj/personal\",'+
        '    \"forks_url\": \"https://api.github.com/repos/anilshivaraj/personal/forks\",'+
        '    \"keys_url\": \"https://api.github.com/repos/anilshivaraj/personal/keys{/key_id}\",'+
        '    \"collaborators_url\": \"https://api.github.com/repos/anilshivaraj/personal/collaborators{/collaborator}\",'+
        '    \"teams_url\": \"https://api.github.com/repos/anilshivaraj/personal/teams\",'+
        '    \"hooks_url\": \"https://api.github.com/repos/anilshivaraj/personal/hooks\",'+
        '    \"issue_events_url\": \"https://api.github.com/repos/anilshivaraj/personal/issues/events{/number}\",'+
        '    \"events_url\": \"https://api.github.com/repos/anilshivaraj/personal/events\",'+
        '    \"assignees_url\": \"https://api.github.com/repos/anilshivaraj/personal/assignees{/user}\",'+
        '    \"branches_url\": \"https://api.github.com/repos/anilshivaraj/personal/branches{/branch}\",'+
        '    \"tags_url\": \"https://api.github.com/repos/anilshivaraj/personal/tags\",'+
        '    \"blobs_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/blobs{/sha}\",'+
        '    \"git_tags_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/tags{/sha}\",'+
        '    \"git_refs_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/refs{/sha}\",'+
        '    \"trees_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/trees{/sha}\",'+
        '    \"statuses_url\": \"https://api.github.com/repos/anilshivaraj/personal/statuses/{sha}\",'+
        '    \"languages_url\": \"https://api.github.com/repos/anilshivaraj/personal/languages\",'+
        '    \"stargazers_url\": \"https://api.github.com/repos/anilshivaraj/personal/stargazers\",'+
        '    \"contributors_url\": \"https://api.github.com/repos/anilshivaraj/personal/contributors\",'+
        '    \"subscribers_url\": \"https://api.github.com/repos/anilshivaraj/personal/subscribers\",'+
        '    \"subscription_url\": \"https://api.github.com/repos/anilshivaraj/personal/subscription\",'+
        '    \"commits_url\": \"https://api.github.com/repos/anilshivaraj/personal/commits{/sha}\",'+
        '    \"git_commits_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/commits{/sha}\",'+
        '    \"comments_url\": \"https://api.github.com/repos/anilshivaraj/personal/comments{/number}\",'+
        '    \"issue_comment_url\": \"https://api.github.com/repos/anilshivaraj/personal/issues/comments{/number}\",'+
        '    \"contents_url\": \"https://api.github.com/repos/anilshivaraj/personal/contents/{+path}\",'+
        '    \"compare_url\": \"https://api.github.com/repos/anilshivaraj/personal/compare/{base}...{head}\",'+
        '    \"merges_url\": \"https://api.github.com/repos/anilshivaraj/personal/merges\",'+
        '    \"archive_url\": \"https://api.github.com/repos/anilshivaraj/personal/{archive_format}{/ref}\",'+
        '    \"downloads_url\": \"https://api.github.com/repos/anilshivaraj/personal/downloads\",'+
        '    \"issues_url\": \"https://api.github.com/repos/anilshivaraj/personal/issues{/number}\",'+
        '    \"pulls_url\": \"https://api.github.com/repos/anilshivaraj/personal/pulls{/number}\",'+
        '    \"milestones_url\": \"https://api.github.com/repos/anilshivaraj/personal/milestones{/number}\",'+
        '    \"notifications_url\": \"https://api.github.com/repos/anilshivaraj/personal/notifications{?since,all,participating}\",'+
        '    \"labels_url\": \"https://api.github.com/repos/anilshivaraj/personal/labels{/name}\",'+
        '    \"releases_url\": \"https://api.github.com/repos/anilshivaraj/personal/releases{/id}\",'+
        '    \"deployments_url\": \"https://api.github.com/repos/anilshivaraj/personal/deployments\",'+
        '    \"created_at\": 1462417511,'+
        '    \"updated_at\": \"2016-05-05T03:11:00Z\",'+
        '    \"pushed_at\": 1472767892,'+
        '    \"git_url\": \"git://github.com/anilshivaraj/personal.git\",'+
        '    \"ssh_url\": \"git@github.com:anilshivaraj/personal.git\",'+
        '    \"clone_url\": \"https://github.com/anilshivaraj/personal.git\",'+
        '    \"svn_url\": \"https://github.com/anilshivaraj/personal\",'+
        '    \"homepage\": null,'+
        '    \"size\": 13,'+
        '    \"stargazers_count\": 0,'+
        '    \"watchers_count\": 0,'+
        '    \"language\": \"JavaScript\",'+
        '    \"has_issues\": true,'+
        '    \"has_downloads\": true,'+
        '    \"has_wiki\": true,'+
        '    \"has_pages\": false,'+
        '    \"forks_count\": 1,'+
        '    \"mirror_url\": null,'+
        '    \"open_issues_count\": 0,'+
        '    \"forks\": 1,'+
        '    \"open_issues\": 0,'+
        '    \"watchers\": 0,'+
        '    \"default_branch\": \"develop\",'+
        '    \"stargazers\": 0,'+
        '    \"master_branch\": \"develop\"'+
        '  },'+
        '  \"pusher\": {'+
        '    \"name\": \"anilshivaraj\",'+
        '    \"email\": \"anil.shivaraj@gmail.com\"'+
        '  },'+
        '  \"sender\": {'+
        '    \"login\": \"anilshivaraj\",'+
        '    \"id\": 5904682,'+
        '    \"avatar_url\": \"https://avatars.githubusercontent.com/u/5904682?v=3\",'+
        '    \"gravatar_id\": \"\",'+
        '    \"url\": \"https://api.github.com/users/anilshivaraj\",'+
        '    \"html_url\": \"https://github.com/anilshivaraj\",'+
        '    \"followers_url\": \"https://api.github.com/users/anilshivaraj/followers\",'+
        '    \"following_url\": \"https://api.github.com/users/anilshivaraj/following{/other_user}\",'+
        '    \"gists_url\": \"https://api.github.com/users/anilshivaraj/gists{/gist_id}\",'+
        '    \"starred_url\": \"https://api.github.com/users/anilshivaraj/starred{/owner}{/repo}\",'+
        '    \"subscriptions_url\": \"https://api.github.com/users/anilshivaraj/subscriptions\",'+
        '    \"organizations_url\": \"https://api.github.com/users/anilshivaraj/orgs\",'+
        '    \"repos_url\": \"https://api.github.com/users/anilshivaraj/repos\",'+
        '    \"events_url\": \"https://api.github.com/users/anilshivaraj/events{/privacy}\",'+
        '    \"received_events_url\": \"https://api.github.com/users/anilshivaraj/received_events\",'+
        '    \"type\": \"User\",'+
        '    \"site_admin\": false'+
        '  }'+
        '}';
        TRAK_Webhook r = TRAK_Webhook.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        TRAK_Webhook.Sender objSender = new TRAK_Webhook.Sender();
        System.assert(objSender != null);
        System.assert(objSender.login == null);
        System.assert(objSender.id == null);
        System.assert(objSender.avatar_url == null);
        System.assert(objSender.gravatar_id == null);
        System.assert(objSender.url == null);
        System.assert(objSender.html_url == null);
        System.assert(objSender.followers_url == null);
        System.assert(objSender.following_url == null);
        System.assert(objSender.gists_url == null);
        System.assert(objSender.starred_url == null);
        System.assert(objSender.subscriptions_url == null);
        System.assert(objSender.organizations_url == null);
        System.assert(objSender.repos_url == null);
        System.assert(objSender.events_url == null);
        System.assert(objSender.received_events_url == null);
        System.assert(objSender.type_X == null);
        System.assert(objSender.site_admin == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
  /*      TRAK_Webhook.Added objAdded = new TRAK_Webhook.Added(System.JSON.createParser(json));
        System.assert(objAdded != null); */

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        TRAK_Webhook.Commits objCommits = new TRAK_Webhook.Commits();
        System.assert(objCommits != null);
        System.assert(objCommits.id == null);
        System.assert(objCommits.tree_id == null);
        System.assert(objCommits.distinct == null);
        System.assert(objCommits.message == null);
        System.assert(objCommits.timestamp == null);
        System.assert(objCommits.url == null);
        System.assert(objCommits.author == null);
        System.assert(objCommits.committer == null);
        System.assert(objCommits.added == null);
        System.assert(objCommits.removed == null);
        System.assert(objCommits.modified == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        TRAK_Webhook.Owner objOwner = new TRAK_Webhook.Owner();
        System.assert(objOwner != null);
        System.assert(objOwner.name == null);
        System.assert(objOwner.email == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        TRAK_Webhook.Repository objRepository = new TRAK_Webhook.Repository();
        System.assert(objRepository != null);
        System.assert(objRepository.id == null);
        System.assert(objRepository.name == null);
        System.assert(objRepository.full_name == null);
        System.assert(objRepository.owner == null);
    //    System.assert(objRepository.private_Z == null);
        System.assert(objRepository.html_url == null);
        System.assert(objRepository.description == null);
        System.assert(objRepository.fork == null);
        System.assert(objRepository.url == null);
        System.assert(objRepository.forks_url == null);
        System.assert(objRepository.keys_url == null);
        System.assert(objRepository.collaborators_url == null);
        System.assert(objRepository.teams_url == null);
        System.assert(objRepository.hooks_url == null);
        System.assert(objRepository.issue_events_url == null);
        System.assert(objRepository.events_url == null);
        System.assert(objRepository.assignees_url == null);
        System.assert(objRepository.branches_url == null);
        System.assert(objRepository.tags_url == null);
        System.assert(objRepository.blobs_url == null);
        System.assert(objRepository.git_tags_url == null);
        System.assert(objRepository.git_refs_url == null);
        System.assert(objRepository.trees_url == null);
        System.assert(objRepository.statuses_url == null);
        System.assert(objRepository.languages_url == null);
        System.assert(objRepository.stargazers_url == null);
        System.assert(objRepository.contributors_url == null);
        System.assert(objRepository.subscribers_url == null);
        System.assert(objRepository.subscription_url == null);
        System.assert(objRepository.commits_url == null);
        System.assert(objRepository.git_commits_url == null);
        System.assert(objRepository.comments_url == null);
        System.assert(objRepository.issue_comment_url == null);
        System.assert(objRepository.contents_url == null);
        System.assert(objRepository.compare_url == null);
        System.assert(objRepository.merges_url == null);
        System.assert(objRepository.archive_url == null);
        System.assert(objRepository.downloads_url == null);
        System.assert(objRepository.issues_url == null);
        System.assert(objRepository.pulls_url == null);
        System.assert(objRepository.milestones_url == null);
        System.assert(objRepository.notifications_url == null);
        System.assert(objRepository.labels_url == null);
        System.assert(objRepository.releases_url == null);
        System.assert(objRepository.deployments_url == null);
        System.assert(objRepository.created_at == null);
        System.assert(objRepository.updated_at == null);
        System.assert(objRepository.pushed_at == null);
        System.assert(objRepository.git_url == null);
        System.assert(objRepository.ssh_url == null);
        System.assert(objRepository.clone_url == null);
        System.assert(objRepository.svn_url == null);
        //System.assert(objRepository.homepage == null);
        System.assert(objRepository.size == null);
        System.assert(objRepository.stargazers_count == null);
        System.assert(objRepository.watchers_count == null);
        System.assert(objRepository.language == null);
        System.assert(objRepository.has_issues == null);
        System.assert(objRepository.has_downloads == null);
        System.assert(objRepository.has_wiki == null);
        System.assert(objRepository.has_pages == null);
        System.assert(objRepository.forks_count == null);
        //System.assert(objRepository.mirror_url == null);
        System.assert(objRepository.open_issues_count == null);
        System.assert(objRepository.forks == null);
        System.assert(objRepository.open_issues == null);
        System.assert(objRepository.watchers == null);
        System.assert(objRepository.default_branch == null);
        System.assert(objRepository.stargazers == null);
        System.assert(objRepository.master_branch == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        TRAK_Webhook objRoot = new TRAK_Webhook();
        System.assert(objRoot != null);
        System.assert(objRoot.ref == null);
        System.assert(objRoot.before == null);
        System.assert(objRoot.after == null);
        System.assert(objRoot.created == null);
        System.assert(objRoot.deleted == null);
        System.assert(objRoot.forced == null);
        //System.assert(objRoot.base_ref == null);
        System.assert(objRoot.compare == null);
        System.assert(objRoot.commits == null);
        System.assert(objRoot.head_commit == null);
        System.assert(objRoot.repository == null);
        System.assert(objRoot.pusher == null);
        System.assert(objRoot.sender == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        TRAK_Webhook.Author objAuthor = new TRAK_Webhook.Author();
        System.assert(objAuthor != null);
        System.assert(objAuthor.name == null);
        System.assert(objAuthor.email == null);
        System.assert(objAuthor.username == null);
    }
    
       /*
* @Method Name  : TRAK_Webhook2Github
* @Description  : This method is to create new test user
* @Return Type  : User
*/
    static testmethod void TRAK_Webhook2Github(){
        List<User> lUser = Test_Utility.createUser('Senior System Administrator', 1, 'swr');
        System.runAs(lUser[0]) {
            Test.StartTest();
            RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
             
        req.requesturi = '/TRAK_Webhook2Github/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('');
        RestContext.request = req;
        RestContext.response= res;
        
        TRAK_Bug__c oDefect = TRAK_Test_Utility.createDefect(1)[0];
        insert oDefect;
        
        String oDefectName = [Select Name from TRAK_Bug__c where Id = :oDefect.Id].Name;
        
        TRAK_User_Story__c oUS = TRAK_Test_Utility.createUserStory(1)[0];
        insert oUS;
        
        String oUSName = [Select Name from TRAK_User_Story__c where Id = :oUS.Id].Name;
        
        // NGIF_Response_HubToTrialForce.ResponseMessage();
    String json = '{'+
        '  \"ref\": \"refs/heads/develop\",'+
        '  \"before\": \"5aa12e2985963ae94813502b24f16f6430eb8687\",'+
        '  \"after\": \"73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '  \"created\": false,'+
        '  \"deleted\": false,'+
        '  \"forced\": false,'+
        '  \"base_ref\": null,'+
        '  \"compare\": \"https://github.com/anilshivaraj/personal/compare/5aa12e298596...73d8a3227540\",'+
        '  \"commits\": ['+
        '    {'+
        '      \"id\": \"73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '      \"tree_id\": \"6406425e6d8800d283a444cbaa654853a3cb6e33\",'+
        '      \"distinct\": true,'+
        '      \"message\": \"'+oDefectName+'\\n\\nyyyyyyyyyyyyyyyyy\",'+
        '      \"timestamp\": \"2016-09-01T18:11:31-04:00\",'+
        '      \"url\": \"https://github.com/anilshivaraj/personal/commit/73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '      \"author\": {'+
        '        \"name\": \"Anil Shivaraj\",'+
        '        \"email\": \"anil.shivaraj@gmail.com\",'+
        '        \"username\": \"anilshivaraj\"'+
        '      },'+
        '      \"committer\": {'+
        '        \"name\": \"GitHub\",'+
        '        \"email\": \"noreply@github.com\",'+
        '        \"username\": \"web-flow\"'+
        '      },'+
        '      \"added\": [],'+
        '      \"removed\": [],'+
        '      \"modified\": ['+
        '        \"README.md\"'+
        '      ]'+
        '    }'+
        '  ],'+
        '  \"head_commit\": {'+
        '    \"id\": \"73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '    \"tree_id\": \"6406425e6d8800d283a444cbaa654853a3cb6e33\",'+
        '    \"distinct\": true,'+
        '    \"message\": \"'+oDefectName+'\\n\\nyyyyyyyyyyyyyyyyy\",'+
        '    \"timestamp\": \"2016-09-01T18:11:31-04:00\",'+
        '    \"url\": \"https://github.com/anilshivaraj/personal/commit/73d8a322754061c345d6b07301d6b5a338ac128c\",'+
        '    \"author\": {'+
        '      \"name\": \"Anil Shivaraj\",'+
        '      \"email\": \"anil.shivaraj@gmail.com\",'+
        '      \"username\": \"anilshivaraj\"'+
        '    },'+
        '    \"committer\": {'+
        '      \"name\": \"GitHub\",'+
        '      \"email\": \"noreply@github.com\",'+
        '      \"username\": \"web-flow\"'+
        '    },'+
        '    \"added\": [],'+
        '    \"removed\": [],'+
        '    \"modified\": ['+
        '      \"README.md\"'+
        '    ]'+
        '  },'+
        '  \"repository\": {'+
        '    \"id\": 58100327,'+
        '    \"name\": \"personal\",'+
        '    \"full_name\": \"anilshivaraj/personal\",'+
        '    \"owner\": {'+
        '      \"name\": \"anilshivaraj\",'+
        '      \"email\": \"anil.shivaraj@gmail.com\"'+
        '    },'+
        '    \"private\": false,'+
        '    \"html_url\": \"https://github.com/anilshivaraj/personal\",'+
        '    \"description\": \"Test commit\",'+
        '    \"fork\": false,'+
        '    \"url\": \"https://github.com/anilshivaraj/personal\",'+
        '    \"forks_url\": \"https://api.github.com/repos/anilshivaraj/personal/forks\",'+
        '    \"keys_url\": \"https://api.github.com/repos/anilshivaraj/personal/keys{/key_id}\",'+
        '    \"collaborators_url\": \"https://api.github.com/repos/anilshivaraj/personal/collaborators{/collaborator}\",'+
        '    \"teams_url\": \"https://api.github.com/repos/anilshivaraj/personal/teams\",'+
        '    \"hooks_url\": \"https://api.github.com/repos/anilshivaraj/personal/hooks\",'+
        '    \"issue_events_url\": \"https://api.github.com/repos/anilshivaraj/personal/issues/events{/number}\",'+
        '    \"events_url\": \"https://api.github.com/repos/anilshivaraj/personal/events\",'+
        '    \"assignees_url\": \"https://api.github.com/repos/anilshivaraj/personal/assignees{/user}\",'+
        '    \"branches_url\": \"https://api.github.com/repos/anilshivaraj/personal/branches{/branch}\",'+
        '    \"tags_url\": \"https://api.github.com/repos/anilshivaraj/personal/tags\",'+
        '    \"blobs_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/blobs{/sha}\",'+
        '    \"git_tags_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/tags{/sha}\",'+
        '    \"git_refs_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/refs{/sha}\",'+
        '    \"trees_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/trees{/sha}\",'+
        '    \"statuses_url\": \"https://api.github.com/repos/anilshivaraj/personal/statuses/{sha}\",'+
        '    \"languages_url\": \"https://api.github.com/repos/anilshivaraj/personal/languages\",'+
        '    \"stargazers_url\": \"https://api.github.com/repos/anilshivaraj/personal/stargazers\",'+
        '    \"contributors_url\": \"https://api.github.com/repos/anilshivaraj/personal/contributors\",'+
        '    \"subscribers_url\": \"https://api.github.com/repos/anilshivaraj/personal/subscribers\",'+
        '    \"subscription_url\": \"https://api.github.com/repos/anilshivaraj/personal/subscription\",'+
        '    \"commits_url\": \"https://api.github.com/repos/anilshivaraj/personal/commits{/sha}\",'+
        '    \"git_commits_url\": \"https://api.github.com/repos/anilshivaraj/personal/git/commits{/sha}\",'+
        '    \"comments_url\": \"https://api.github.com/repos/anilshivaraj/personal/comments{/number}\",'+
        '    \"issue_comment_url\": \"https://api.github.com/repos/anilshivaraj/personal/issues/comments{/number}\",'+
        '    \"contents_url\": \"https://api.github.com/repos/anilshivaraj/personal/contents/{+path}\",'+
        '    \"compare_url\": \"https://api.github.com/repos/anilshivaraj/personal/compare/{base}...{head}\",'+
        '    \"merges_url\": \"https://api.github.com/repos/anilshivaraj/personal/merges\",'+
        '    \"archive_url\": \"https://api.github.com/repos/anilshivaraj/personal/{archive_format}{/ref}\",'+
        '    \"downloads_url\": \"https://api.github.com/repos/anilshivaraj/personal/downloads\",'+
        '    \"issues_url\": \"https://api.github.com/repos/anilshivaraj/personal/issues{/number}\",'+
        '    \"pulls_url\": \"https://api.github.com/repos/anilshivaraj/personal/pulls{/number}\",'+
        '    \"milestones_url\": \"https://api.github.com/repos/anilshivaraj/personal/milestones{/number}\",'+
        '    \"notifications_url\": \"https://api.github.com/repos/anilshivaraj/personal/notifications{?since,all,participating}\",'+
        '    \"labels_url\": \"https://api.github.com/repos/anilshivaraj/personal/labels{/name}\",'+
        '    \"releases_url\": \"https://api.github.com/repos/anilshivaraj/personal/releases{/id}\",'+
        '    \"deployments_url\": \"https://api.github.com/repos/anilshivaraj/personal/deployments\",'+
        '    \"created_at\": 1462417511,'+
        '    \"updated_at\": \"2016-05-05T03:11:00Z\",'+
        '    \"pushed_at\": 1472767892,'+
        '    \"git_url\": \"git://github.com/anilshivaraj/personal.git\",'+
        '    \"ssh_url\": \"git@github.com:anilshivaraj/personal.git\",'+
        '    \"clone_url\": \"https://github.com/anilshivaraj/personal.git\",'+
        '    \"svn_url\": \"https://github.com/anilshivaraj/personal\",'+
        '    \"homepage\": null,'+
        '    \"size\": 13,'+
        '    \"stargazers_count\": 0,'+
        '    \"watchers_count\": 0,'+
        '    \"language\": \"JavaScript\",'+
        '    \"has_issues\": true,'+
        '    \"has_downloads\": true,'+
        '    \"has_wiki\": true,'+
        '    \"has_pages\": false,'+
        '    \"forks_count\": 1,'+
        '    \"mirror_url\": null,'+
        '    \"open_issues_count\": 0,'+
        '    \"forks\": 1,'+
        '    \"open_issues\": 0,'+
        '    \"watchers\": 0,'+
        '    \"default_branch\": \"develop\",'+
        '    \"stargazers\": 0,'+
        '    \"master_branch\": \"develop\"'+
        '  },'+
        '  \"pusher\": {'+
        '    \"name\": \"anilshivaraj\",'+
        '    \"email\": \"anil.shivaraj@gmail.com\"'+
        '  },'+
        '  \"sender\": {'+
        '    \"login\": \"anilshivaraj\",'+
        '    \"id\": 5904682,'+
        '    \"avatar_url\": \"https://avatars.githubusercontent.com/u/5904682?v=3\",'+
        '    \"gravatar_id\": \"\",'+
        '    \"url\": \"https://api.github.com/users/anilshivaraj\",'+
        '    \"html_url\": \"https://github.com/anilshivaraj\",'+
        '    \"followers_url\": \"https://api.github.com/users/anilshivaraj/followers\",'+
        '    \"following_url\": \"https://api.github.com/users/anilshivaraj/following{/other_user}\",'+
        '    \"gists_url\": \"https://api.github.com/users/anilshivaraj/gists{/gist_id}\",'+
        '    \"starred_url\": \"https://api.github.com/users/anilshivaraj/starred{/owner}{/repo}\",'+
        '    \"subscriptions_url\": \"https://api.github.com/users/anilshivaraj/subscriptions\",'+
        '    \"organizations_url\": \"https://api.github.com/users/anilshivaraj/orgs\",'+
        '    \"repos_url\": \"https://api.github.com/users/anilshivaraj/repos\",'+
        '    \"events_url\": \"https://api.github.com/users/anilshivaraj/events{/privacy}\",'+
        '    \"received_events_url\": \"https://api.github.com/users/anilshivaraj/received_events\",'+
        '    \"type\": \"User\",'+
        '    \"site_admin\": false'+
        '  }'+
        '}';
        TRAK_Webhook responseJSON = TRAK_Webhook.parse(json);
    //    String responseJSON_Error = '{"request":{"businessTransactionId":"SITE-0082","sourceName":"MDM","receivedDateTime":1466084072828},"response":[{"targetName":"Trialforce","payload":"{"status":[{"failure":null,"failure":{"oid":"00154000005dW66AAE","targetOID":"283"},"sourceType":"SITE"}]}","status":200,"error":false}]}';        
        req.requestBody = Blob.valueOf(json);
        TRAK_Webhook2Github.TRAK_Webhook2Github();
        json = json.replaceAll(oDefectName,oUSName);
        req.requestBody = Blob.valueOf(json);
        TRAK_Webhook2Github.TRAK_Webhook2Github();
    /*    req.requestBody = Blob.valueof(responseJSON_Error);
        NGIF_Response_HubToTrialForce.ResponseMessage(); */
            Test.StopTest();
        }
    }
    
}