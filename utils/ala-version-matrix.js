#!/usr/bin/env node

/*
This script displays a table comparing versions between ALA (ala.org.au) 
and SBDI (biodiversitydata.se) of the various LA services. 

The script uses the buildInfo endpoint to get version information. 
Unfortunately this endpoint is not available on all services. Those services 
are listed with blank versions. This could be improved upon since there are 
other sources for version infomation like openapi or github.
*/

const blankService = {
    runtimeEnvironment: {},
    buildInfoProperties: {},
}

const fetchServiceBuildInfo = async(service, prefix) => {
    const hostProperty = prefix + 'Host';
    const urlProperty = prefix + 'Url';
    const domainSuffix = {
        ala: '.ala.org.au',
        sbdi: '.biodiversitydata.se'
    }
    
    if (!(hostProperty in service)) {
        service[hostProperty] = service.name;
    }
   
    const context = (prefix + 'Context' in service) ? service[prefix + 'Context'] : '';
    service[urlProperty] = 'https://' + service[hostProperty] + domainSuffix[prefix] + context + '/buildInfo?format=json'
    //console.log(service[urlProperty]);

    try {
        const response = await fetch(service[urlProperty]);
        return response.json();
    } catch (error) {
        console.log('Failed to fetch: ' + service[urlProperty])
        return blankService;
    }
}

const fetchServiceGithubGradle = async(service, prefix) => {
    const urlProperty = prefix + 'Url';
    const githubOrg = {
        ala: 'AtlasOfLivingAustralia',
        sbdi: 'biodiversitydata-se'
    }
    service[urlProperty] = 'https://raw.githubusercontent.com/' + githubOrg[prefix] + '/' + service.repo + '/master/build.gradle'
    //console.log(service[urlProperty]);

    try {
        const response = await fetch(service[urlProperty]);
        const body = await response.text();
        const matchResult = body.match(/\nversion(?: | ?= ?)(?:"|')(.*)(?:"|')\n/);
        return  {
            runtimeEnvironment: {
                'app.version': matchResult[1]
            },
            buildInfoProperties: {},
        }
    } catch (error) {
        console.log('Failed to fetch: ' + service[urlProperty])
        return blankService;
    }
}

const decorateService = async(service, prefix) => {
    if (service.source === 'none') {
        service[prefix] = blankService;
    } else if (service.source === 'githubGradle') {
        service[prefix] = await fetchServiceGithubGradle(service, prefix);
    } else { // source = buildInfo
        service[prefix] = await fetchServiceBuildInfo(service, prefix);
    }
}

const fetchServices = async() => {
    
    const services = [
        {
            name: 'apikey',
            // buildInfo not available
            source: 'githubGradle',
            repo: 'apikey',
        },
        {
            name: 'cas',
            source: 'none', // buildInfo not available
        },
        {
            name: 'collections',
        },
        {
            name: 'dashboard',
        },
        {
            name: 'images',
        },
        {
            name: 'lists',
        },
        {
            name: 'logger',
            // requires auth
            //alaContext: '/alaAdmin',
            //sbdiContext: '/alaAdmin',
            source: 'githubGradle',
            repo: 'logger-service',
        },
        {
            name: 'namematching',
            source: 'none', // buildInfo not available
        },
        {
            name: 'records',
            alaHost: 'biocache',
        },
        {
            name: 'records-service',
            // ?format=json doesn't work
            //alaHost: 'biocache',
            //sbdiHost: 'records',
            //alaContext: '/ws',
            //sbdiContext: '/ws',
            source: 'githubGradle',
            repo: 'biocache-service',
        },
        {
            name: 'regions',
        },
        {
            name: 'sds',
        },
        {
            name: 'spatial',
        },
        {
            name: 'spatial-service',
            alaHost: 'spatial',
            sbdiHost: 'spatial',
            alaContext: '/ws',
            sbdiContext: '/ws',
        },
        {
            name: 'species',
            alaHost: 'bie',
        },
        {
            name: 'species-service',
            // requires auth
            //alaHost: 'bie',
            //sbdiHost: 'species',
            //alaContext: '/ws/alaAdmin',
            //sbdiContext: '/ws/alaAdmin',
            source: 'githubGradle',
            repo: 'bie-index',
        },
        {
            name: 'userdetails',
             // requires auth
            //alaHost: 'auth',
            //sbdiHost: 'auth',
            //alaContext: '/userdetails/alaAdmin',
            //sbdiContext: '/userdetails/alaAdmin',
            source: 'githubGradle',
            repo: 'userdetails',
        },
    ];

    process.stdout.write('Fetching');
    for (var service of services) {
        await decorateService(service, 'ala');
        await decorateService(service, 'sbdi');
        process.stdout.write('.');
    };
    console.log('\n');

    return services;
}

const isBehind = (service) => {
    return service.ala.runtimeEnvironment['app.version'] != service.sbdi.runtimeEnvironment['app.version'];
}

const format = (value) => {
    if (value === 'unspecified') return '-';
    return value || '-';
}

const displayServices = (services) => {
    console.log(
        'App'.padStart(27),
        'App'.padStart(10),
        'Java'.padStart(12),
        'Java'.padStart(12),
        'Grails'.padStart(10),
        'Grails'.padStart(10),
        );
    console.log(
        'Service'.padEnd(16),
        'ALA'.padStart(10),
        'SBDI'.padStart(10),
        'ALA'.padStart(12),
        'SBDI'.padStart(12),
        'ALA'.padStart(10),
        'SBDI'.padStart(10),
        ' Git commit SBDI',
        );
    console.log('-'.repeat(112));

    services.forEach(service => {
        console.log(
            ((isBehind(service) ? '*' : '') + service.name).padEnd(16),
            format(service.ala.runtimeEnvironment['app.version']).padStart(10),
            format(service.sbdi.runtimeEnvironment['app.version']).padStart(10),
            format(service.ala.runtimeEnvironment['java.version']).padStart(12),
            format(service.sbdi.runtimeEnvironment['java.version']).padStart(12),
            format(service.ala.runtimeEnvironment['app.grails.version']).padStart(10).padEnd(11),
            format(service.sbdi.runtimeEnvironment['app.grails.version']).padStart(10).padEnd(11),
            format(service.sbdi.buildInfoProperties['git.commit.date']),
            )
    });
}

const run = async() => {
    const services = await fetchServices();
    displayServices(services);
}

run();
