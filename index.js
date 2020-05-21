var path = require('path');

const redirects = {
  "/about-us": { to: "/about", statusCode: 301 },
  "/contact-us/head-office": { to: "/contact/head-office", statusCode: 302 },
};

exports.handler = async event => {
  const { request } = event.Records[0].cf;
  const normalisedUri = normalise(request.uri);
  const redirect = redirects[normalisedUri];
  if (redirect) {
    return redirectTo(redirect.to, redirect.statusCode);
  }
  if (!hasExtension(request.uri)) {
    request.uri = trimSlash(request.uri) + "/index.html";
  }
  return request;
};

const trimSlash = uri => hasTrailingSlash(uri) ? uri.slice(0, -1) : uri;
const normalise = uri => trimSlash(uri).toLowerCase();
const hasExtension = uri => path.extname(uri) !== '';
const hasTrailingSlash = uri => uri.endsWith('/');

const redirectTo = (to, statusCode) => ({
  status: statusCode.toString(),
  statusDescription: 'Found',
  headers: {
    location: [{
      key: 'Location',
      value: to,
    }],
  },
});