'use strict';

const fs = require('fs'),
      gulp = require('gulp'),
      replace = require('gulp-replace'),
      coffee = require('gulp-coffee'),
      concat = require('gulp-concat'),
      sass = require('gulp-sass'),
      jade = require('gulp-jade')
;

gulp.task('templates', () => {
  return gulp.src('./templates/*.jade')
    .pipe(jade({}))
    .pipe(gulp.dest('./build/'))
});

gulp.task('coffee', ['templates'], () => {
  return gulp.src('./coffee/*.coffee')
    .pipe(replace(include.re, include))
    .pipe(coffee())
    .pipe(concat('index.js'))
    .pipe(gulp.dest('./'))
});

gulp.task('styles', () => {
  return gulp.src('./sass/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(concat('styles.css'))
    .pipe(gulp.dest('./'));
});

gulp.task('default', ['coffee', 'styles'])


function include(match, file1, file2) {
  return fs.readFileSync(
    file1 || file2,
    { encoding: 'utf-8' }
  );
}
include.re = /#include\s*\((?:\s*(?:'([^']+)')|(?:"([^"]+)")\s*)\)/
