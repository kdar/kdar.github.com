'use strict';

var gulp = require('gulp');
var gulpCopy = require('gulp-copy');
var gulpif = require('gulp-if');
var gutil = require('gulp-util');
var sourcemaps = require('gulp-sourcemaps');
var args = require('yargs').argv;
var assign = require('lodash.assign');

// css imports
var sass = require('gulp-sass');
var purify = require('gulp-purifycss');
var postcss = require('gulp-postcss');
var pcImport = require("postcss-import")
var autoprefixer = require('autoprefixer');
var cssnano = require('gulp-cssnano');
//var discardComments = require('postcss-discard-comments');

// js imports
var browserify = require('browserify');
var watchify = require('watchify');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');
var uglify = require('gulp-uglify');

var isProduction = args.production;

var browserifyOpts = {
  entries: './src/js/main.js',
  debug: !isProduction
};

gulp.task('vendor', function() {
  gulp.src('node_modules/jquery/dist/*')
  .pipe(gulpCopy('static/vendor/jquery', {
    prefix: 3
  }));
});

gulp.task('js', function() {
  var b = browserify(assign({}, watchify.args, browserifyOpts));

  return jsBundle(b);
});

gulp.task('sass', function() {
  gulp.src(['./src/scss/**/*.scss'])
    .pipe(gulpif(!isProduction, sourcemaps.init()))
    .pipe(sass().on('error', sass.logError))
    .pipe(postcss([autoprefixer, pcImport]))
    //.pipe(purify(['./static/**/*.js', './layouts/**/*.html']))
    .pipe(gulpif(isProduction, cssnano({autoprefixer: false, safe: true})))
    .pipe(gulpif(!isProduction, sourcemaps.write()))
    .pipe(gulp.dest('./static/css'));
});

gulp.task('build', ['js', 'sass']);

gulp.task('watch', function() {
  gulp.watch('./src/scss/**/*.scss', ['sass']);

  var b = watchify(browserify(assign({}, watchify.args, browserifyOpts)));
  b.on('log', gutil.log); // output build logs to terminal
  b.on('update', function() { // on any dep update, runs the bundler
    return jsBundle(b);
  });

  return jsBundle(b);
});

function jsBundle(b) {
  return b.bundle()
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source('main.js'))
    .pipe(buffer())
    .pipe(gulpif(!isProduction, sourcemaps.init({loadMaps: true})))
      // Add transformation tasks to the pipeline here.
      .pipe(uglify())
    .pipe(gulpif(!isProduction, sourcemaps.write('./')))
    .pipe(gulp.dest('./static/js/'));
}
