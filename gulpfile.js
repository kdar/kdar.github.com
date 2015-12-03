'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var gulpCopy = require('gulp-copy');

gulp.task('vendor', function() {
  gulp.src('node_modules/jquery/dist/*')
  .pipe(gulpCopy('static/vendor/jquery', {
    prefix: 3
  }));
  gulp.src('node_modules/semantic-ui/dist/**/*')
  .pipe(gulpCopy('static/vendor/semantic', {
    prefix: 3
  }));
});

gulp.task('sass', function() {
  gulp.src('./static/scss/**/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass({
      outputStyle: 'compressed'
    }).on('error', sass.logError))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./static/css'));
});

gulp.task('watch', function() {
  gulp.watch('./static/scss/**/*.scss', ['sass']);
});
