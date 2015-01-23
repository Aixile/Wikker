var FAQ = angular.module('FAQ', ['ngSanitize']);

FAQ.controller('FAQCtrl', function ($scope, $http) {
	$http.get('questions.json').success(function(data) {
		$scope.questions = data;
	});
});
