import unittest
import os
import testLib

class TestAdd(testLib.RestTestCase):
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        # copied from testSimple
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAddSucess(self):
        respdata=self.makeRequest("/users/add", method="POST", data={'user':'jack', 'password':'j'})
        self.assertResponse(respData, count = 1)
    
    def testAddFailNoUser(self):
        respdata=self.makeRequest("/users/add", method="POST", data={'user': '', 'password':'j'} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_BAD_USERNAME)

    def testAddFailUserLong(self):
        respdata=self.makeRequest("/users/add", method="POST", data={ 'user':'tenletters'*20, 'password':'j'} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_BAD_USERNAME)

    def testAddFailPWLong(self):
        respdata=self.makeRequest("/users/add", method="POST", data={'user':'jack', 'password':'tenletters'*20} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_BAD_PASSWORD)

    def testAddFailExist(self):
        self.makeRequest("/users/add", method="POST", data={'user':'jack', 'password':'j'})
        respdata=self.makeRequest("/users/add", method="POST", data={'user':'jack', 'password':'k'} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_USER_EXISTS)


class TestLogin(testLib.RestTestCase):
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        # copied from testSimple
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testLoginSuccess(self):
        self.makeRequest("/users/add", method="POST", data={'user':'jack', 'password':'j'})
        respdata=self.makeRequest("/users/login", method="POST", data={'user':'jack', 'password':'j'})
        self.assertResponse(respData, count = 1, errCode = testLib.RestTestCase.SUCCESS)

    def testLoginFailWrongPW(self):
        self.makeRequest("/users/add", method="POST", data={'user':'jack', 'password':'j'})
        respdata=self.makeRequest("/users/login", method="POST", data={'user':'jack', 'password':'jack'})
        self.assertResponse(respData, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS)

    def testLoginMultiple(self):
        self.makeRequest("/users/add", method="POST", data={'user':'jack', 'password':'j'})
        respdata=self.makeRequest("/users/login", method="POST", data={'user':'jack', 'password':'j'})
        self.assertResponse(respData, count = 1)
        respdata=self.makeRequest("/users/login", method="POST", data={'user':'jack', 'password':'j'})
        self.assertResponse(respData, count = 2)
        respdata=self.makeRequest("/users/login", method="POST", data={'user':'jack', 'password':'j'})
        respdata=self.makeRequest("/users/login", method="POST", data={'user':'jack', 'password':'j'})
        self.assertResponse(respData, count = 4)