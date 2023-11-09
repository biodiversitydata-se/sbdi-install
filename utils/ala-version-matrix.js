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

const fetchService = async(url) => {
    try {
        const response = await fetch(url);
        return response.json();
    } catch (error) {
        console.log('Failed to fetch: ' + url)
        return blankService;
    }      
}

const decorateService = async(service, prefix) => {
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
    service[prefix] = service.skipFetch ? blankService : await fetchService(service[urlProperty]);
}

const fetchServices = async() => {
    
    const services = [
        {
            name: 'apikey',
            skipFetch: true, // buildInfo not available
        },
        {
            name: 'cas',
            skipFetch: true, // buildInfo not available
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
            alaContext: '/alaAdmin',
            sbdiContext: '/alaAdmin',
            skipFetch: true, // requires auth
        },
        {
            name: 'namematching',
            skipFetch: true, // buildInfo not available
        },
        {
            name: 'records',
            alaHost: 'biocache',
        },
        {
            name: 'records-service',
            alaHost: 'biocache',
            sbdiHost: 'records',
            alaContext: '/ws',
            sbdiContext: '/ws',
            skipFetch: true, // ?format=json doesn't work
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
            alaHost: 'bie',
            sbdiHost: 'species',
            alaContext: '/ws/alaAdmin',
            sbdiContext: '/ws/alaAdmin',
            skipFetch: true, // requires auth
        },
        {
            name: 'userdetails',
            alaHost: 'auth',
            sbdiHost: 'auth',
            alaContext: '/userdetails/alaAdmin',
            sbdiContext: '/userdetails/alaAdmin',
            skipFetch: true, // requires auth
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
        'App'.padStart(26), 
        'App'.padStart(10),
        'Java'.padStart(12),
        'Java'.padStart(12),
        'Grails'.padStart(10),
        'Grails'.padStart(10),
        );
    console.log(
        'Service'.padEnd(15), 
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
            ((isBehind(service) ? '*' : '') + service.name).padEnd(15), 
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
